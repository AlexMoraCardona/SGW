class EpidemiologicalSurveillanceProgramsController < ApplicationController

  before_action :set_epidemiological_surveillance_program, only: %i[show edit update destroy]

  def index
    @epidemiological_surveillance_programs = EpidemiologicalSurveillanceProgram.includes(:entity, :responsible).order(created_at: :desc)
  end

  def show
    @surveillance_surveys =  @epidemiological_surveillance_program.surveillance_surveys.order(created_at: :desc)
    @surveillance_cases = @epidemiological_surveillance_program.epidemiological_surveillance_cases.includes(:user, :responsible).order(opened_at: :desc)
    @workers_count = @epidemiological_surveillance_program.surveillance_workers.count        
    @surveillance_workers = @epidemiological_surveillance_program.surveillance_workers          
    @surveillance_activities = @epidemiological_surveillance_program.surveillance_activities          
        
    # ==========================================
    # INDICADORES GENERALES DEL PROGRAMA SVE
    # ==========================================
    @total_cases = @surveillance_cases.count
    @cases_identified = @surveillance_cases.count(&:identified?)
    @cases_in_evaluation = @surveillance_cases.count(&:in_evaluation?)
    @cases_in_follow_up = @surveillance_cases.count(&:in_follow_up?)
    @cases_closed = @surveillance_cases.count(&:closed?)
    @cases_not_case = @surveillance_cases.count(&:not_case?)
          
    # ==========================================
    # CASOS ACTIVOS
    # ==========================================
    @active_cases = @surveillance_cases.where(status: [:identified, :in_evaluation, :in_follow_up]).count

    # ==========================================
    # INDICADORES DE SEGUIMIENTO
    # ==========================================
    @total_follow_ups = EpidemiologicalSurveillanceCaseFollowUp.joins(:epidemiological_surveillance_case).where(epidemiological_surveillance_cases: {epidemiological_surveillance_program_id: @epidemiological_surveillance_program.id}).count
    
    @cases_with_follow_ups = @surveillance_cases.select { |sve_case| sve_case.status.in?(["identified", "in_evaluation", "in_follow_up"]) }.count do |sve_case|
      sve_case.follow_ups.exists?
    end
  
    @follow_up_coverage_percentage =
      if @active_cases > 0
        ((@cases_with_follow_ups.to_f / @active_cases) * 100).round(1)
      else
        0
      end

    # ============================================================
    # ACTIVIDADES DEL PROGRAMA SVE
    # ============================================================

    @surveillance_activities = @epidemiological_surveillance_program.surveillance_activities.includes(:responsible).order(planned_date: :asc, created_at: :asc)
    @activities_total = @surveillance_activities.count
    @activities_pending = @surveillance_activities.count(&:pending?)
    @activities_in_progress = @surveillance_activities.count(&:in_progress?)
    @activities_completed = @surveillance_activities.count(&:completed?)
    @activities_cancelled = @surveillance_activities.count(&:cancelled?)

    # Actividades atrasadas
    @activities_overdue = @surveillance_activities.select do |activity|
        activity.planned_date.present? &&
        activity.planned_date < Date.current &&
        !activity.completed? &&
        !activity.cancelled?
    end

    # Actividades próximas a vencer
    @activities_upcoming = @surveillance_activities.select do |activity|
        activity.planned_date.present? &&
        activity.planned_date >= Date.current &&
        activity.planned_date <= Date.current + 7.days &&
        !activity.completed? &&
        !activity.cancelled?
    end

    # Porcentaje de cumplimiento
    @activities_completion_percentage =
      if @activities_total.positive?
        ((@activities_completed.to_f / @activities_total) * 100).round(1)
      else
        0
      end      
  
    @activities_by_month = {}
    @surveillance_activities.each do |activity|
      next if activity.planned_date.blank?
      month = activity.planned_date.beginning_of_month
      @activities_by_month[month] ||= {planned: 0, completed: 0}
      @activities_by_month[month][:planned] += 1
      if activity.completed?
        @activities_by_month[month][:completed] += 1
      end
    end

    @activities_planned_chart = @activities_by_month.sort.map do |month, values| 
      [month.strftime("%Y-%m"), values[:planned]]
    end

    @activities_completed_chart = @activities_by_month.sort.map do |month, values|
      [month.strftime("%Y-%m"), values[:completed]]
    end

    # ==========================================
    # PROMEDIO DE SEGUIMIENTOS POR CASO
    # ==========================================

    @average_follow_ups_per_case =
        if @total_cases > 0
          (@total_follow_ups.to_f / @total_cases).round(1)
        else
          0
        end  

    # ==========================================
    # GRÁFICO - SEGUIMIENTOS POR TIPO
    # ==========================================

    @follow_ups_by_type =  EpidemiologicalSurveillanceCaseFollowUp.joins(:epidemiological_surveillance_case).where(epidemiological_surveillance_cases: {epidemiological_surveillance_program_id: @epidemiological_surveillance_program.id}).group(:follow_up_type).count
    @follow_up_type_names = {
      "identification"     => "Identificación",
      "initial_evaluation" => "Evaluación inicial",
      "follow_up"          => "Seguimiento",
      "visit"              => "Visita",
      "phone_contact"      => "Contacto telefónico",
      "document_review"    => "Revisión documental",
      "closure"            => "Cierre"
    }

    @follow_ups_by_type =  @follow_ups_by_type.map do |follow_up_type, quantity|
      [
        @follow_up_type_names[follow_up_type] || "Sin tipo",
        quantity
      ]
    end
    .sort_by { |item| -item[1] }        
  
    # ==========================================
    # ALERTAS DE SEGUIMIENTO
    # ==========================================

    today = Date.current

    @follow_ups_alerts =
    EpidemiologicalSurveillanceCaseFollowUp
      .joins(:epidemiological_surveillance_case)
      .where(
        epidemiological_surveillance_cases: {
          epidemiological_surveillance_program_id:
            @epidemiological_surveillance_program.id
        }
      )
      .where.not(
        epidemiological_surveillance_cases: {
          status: EpidemiologicalSurveillanceCase.statuses[:closed]
        }
      )
      .where.not(next_follow_up_date: nil)
      .includes(
        :user,
        :epidemiological_surveillance_case
      )
      .order(next_follow_up_date: :asc)

    @follow_ups_overdue = @follow_ups_alerts.count do |follow_up|
      follow_up.next_follow_up_date.to_date < today
    end

    @follow_ups_upcoming = @follow_ups_alerts.count do |follow_up|
        date = follow_up.next_follow_up_date.to_date
        date >= today && date <= today + 7.days
    end

    @follow_ups_scheduled = @follow_ups_alerts.count do |follow_up|
      follow_up.next_follow_up_date.to_date > today + 7.days

    end

    # ==========================================
    # CASOS ABIERTOS SIN PRÓXIMO SEGUIMIENTO
    # ==========================================

    @cases_without_next_follow_up =
    @surveillance_cases.select do |sve_case|
      sve_case.status != "closed" && sve_case.status != "not_case" && sve_case.follow_ups.none? do |follow_up|
        follow_up.next_follow_up_date.present?
      end
    end

    # ==========================================
    # PORCENTAJE DE CASOS CERRADOS
    # ==========================================

    @closure_percentage =  if @total_cases > 0
        ((@cases_closed.to_f / @total_cases) * 100).round(1)
    else
      0
    end     
  
    # ==========================================
    # PORCENTAJE DE CASOS ACTIVOS
    # ==========================================

    @active_cases_percentage = if @total_cases > 0
        ((@active_cases.to_f / @total_cases) * 100).round(1)
    else
      0
    end
  
    # ==========================================
    # PORCENTAJE DE CASOS "NO ES CASO"
    # ==========================================

    @not_case_percentage = if @total_cases > 0
      ((@cases_not_case.to_f / @total_cases) * 100).round(1)
    else
      0
    end  

    # ==========================================
    # GRÁFICO - CASOS POR ESTADO
    # ==========================================

    @cases_by_status = [
      ["Identificados", @surveillance_cases.where(status: :identified).count],
      ["En evaluación", @surveillance_cases.where(status: :in_evaluation).count],
      ["En seguimiento", @surveillance_cases.where(status: :in_follow_up).count],
      ["Cerrados", @surveillance_cases.where(status: :closed).count],
      ["No es caso", @surveillance_cases.where(status: :not_case).count]
    ]

    @cases_by_source = [
      ["Evento", @surveillance_cases.where(source_type: :event).count],
      ["Encuesta", @surveillance_cases.where(source_type: :survey).count],
      ["Otra fuente", @surveillance_cases.where(source_type: :other).count]
    ]

    # ==========================================
    # GRÁFICO - CASOS POR ÁREA
    # ==========================================

    @cases_by_area = @surveillance_cases.group_by { |sve_case| sve_case.user&.area_employee }.transform_values(&:count)
    @cases_by_area =
        @cases_by_area.map do |area_id, quantity|
            area_name =  CompanyArea.where(id: area_id, entity_id: @epidemiological_surveillance_program.entity_id).pick(:name)
            [area_name.presence || "Sin área",  quantity]
        end
        .sort_by { |item| -item[1] }

    # ==========================================
    # GRÁFICO - CASOS POR CARGO
    # ==========================================
    @cases_by_position = @surveillance_cases.group_by { |sve_case| sve_case.user&.activity }.transform_values(&:count)
    @cases_by_position = @cases_by_position.map do |position_id, quantity|
      position_name =  CompanyPosition.where(id: position_id, entity_id: @epidemiological_surveillance_program.entity_id).pick(:name)
      [position_name.presence || "Sin cargo", quantity]
    end
    .sort_by { |item| -item[1] }

    # ==========================================
    # TIEMPO PROMEDIO HASTA EL PRIMER SEGUIMIENTO
    # ==========================================
    first_follow_up_times = []
    @surveillance_cases.each do |sve_case|
      next unless sve_case.opened_at.present?
      first_follow_up = sve_case.follow_ups.where.not(follow_up_date: nil).order(follow_up_date: :asc).first
      next unless first_follow_up.present?
      days = (first_follow_up.follow_up_date.to_date - sve_case.opened_at.to_date).to_i
      next if days < 0
      first_follow_up_times << days
    end

    @average_days_to_first_follow_up = if first_follow_up_times.present?
        (first_follow_up_times.sum.to_f / first_follow_up_times.length).round(1)
    else
      0
    end
  
    # ==========================================
    # TIEMPO PROMEDIO DE ATENCIÓN
    # CASOS CERRADOS
    # ==========================================
    closed_case_times = []
    @surveillance_cases.where(status: :closed).each do |sve_case|
        next unless sve_case.opened_at.present?
        next unless sve_case.closed_at.present?

        days = (sve_case.closed_at.to_date - sve_case.opened_at.to_date).to_i
        next if days < 0
        closed_case_times << days
    end

    @average_case_attention_days =  if closed_case_times.present?
        (closed_case_times.sum.to_f / closed_case_times.length).round(1)
    else
      0
    end  
  
    # ==========================================
    # GRÁFICO - CASOS CREADOS POR MES
    # ==========================================
    @cases_by_month = @surveillance_cases.group_by { |sve_case| sve_case.opened_at.beginning_of_month }.sort.map do |month, cases|
        [I18n.l(month, format: "%b %Y"), cases.count]
    end

    # ==========================================
    # INSPECCIONES DEL PROGRAMA SVE
    # ==========================================

    @surveillance_inspections =
      @epidemiological_surveillance_program
        .surveillance_inspections
        .includes(:company_area)
        .order(fecha: :desc)

    @cant_inspecciones = @surveillance_inspections.count

# ==========================================
# NOVEDADES DE EMPLEADOS RELACIONADAS CON SVE
# ==========================================

if @epidemiological_surveillance_program.surveillance_configuration.present?

  @sve_events =
    Event
      .joins(detail_disease: :surveillance_configuration)
      .includes(
        :user,
        :detail_disease,
        detail_disease: :surveillance_configuration
      )
      .where(
        entity_id: @epidemiological_surveillance_program.entity_id,
        surveillance_configurations: {
          id: @epidemiological_surveillance_program.surveillance_configuration_id
        }
      )
      .order(date_new: :desc)

  @cant_novedades_empleados = @sve_events.count

else

  @sve_events = Event.none
  @cant_novedades_empleados = 0

end


  end

  def new
    @epidemiological_surveillance_program = EpidemiologicalSurveillanceProgram.new

    @entities = Entity.order(:business_name)
    @users = User.where(state: 1).order(:name)

    @surveillance_configurations = SurveillanceConfiguration.where(status: :active).order(:name)
  end




  def create
    @epidemiological_surveillance_program = EpidemiologicalSurveillanceProgram.new(epidemiological_surveillance_program_params)

    begin
      ActiveRecord::Base.transaction do

        # Crear el programa SVE
        @epidemiological_surveillance_program.save!

        # Obtener la configuración seleccionada
        configuration =
          SurveillanceConfiguration
            .includes(
              surveillance_configuration_questions:
                :surveillance_configuration_question_options
            )
            .find(
              @epidemiological_surveillance_program
                .surveillance_configuration_id
            )

        # Crear la encuesta
        survey =
          @epidemiological_surveillance_program
            .surveillance_surveys
            .create!(
              name: configuration.name
            )

        # Copiar preguntas activas
        configuration
          .surveillance_configuration_questions
          .where(status: :active)
          .order(position: :asc)
          .each do |config_question|

          question =
            survey
              .surveillance_questions
              .create!(
                question: config_question.question,
                question_type: config_question.question_type,
                position: config_question.position,
                required: config_question.required,
                help_text: config_question.help_text
              )

          # Copiar opciones activas
          config_question
            .surveillance_configuration_question_options
            .where(status: :active)
            .order(position: :asc)
            .each do |config_option|

            question
              .surveillance_question_options
              .create!(
                option_text: config_option.option,
                position: config_option.position
              )
          end
        end
      end

      redirect_to(epidemiological_surveillance_program_path(@epidemiological_surveillance_program), notice: "El programa SVE y su encuesta fueron creados correctamente.")
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Error creando programa SVE: #{e.message}")
      @entities = Entity.order(:business_name)
      @users = User.where(state: 1).order(:name)
      @surveillance_configurations = SurveillanceConfiguration.where(status: :active).order(:name)
      @epidemiological_surveillance_program.errors.add(:base, "No fue posible crear el programa y su encuesta.")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @entities = Entity.order(:business_name)

    @users = User.where(state: 1).order(:name)

    @surveillance_configurations = SurveillanceConfiguration.where(status: :active).order(:name)
  end

  def update
    if @epidemiological_surveillance_program.update(epidemiological_surveillance_program_params)
      redirect_to @epidemiological_surveillance_program, notice: "El programa de vigilancia epidemiológica fue actualizado correctamente."
    else
      @entities = Entity.order(:business_name)
      @users = User.where(state: 1).order(:name)
      render :edit, status: :unprocessable_entity
    end

  end

  def destroy
    if @epidemiological_surveillance_program.destroy
      redirect_to epidemiological_surveillance_programs_path, notice: "El programa fue eliminado correctamente."
    else
      redirect_to @epidemiological_surveillance_program, alert: "No fue posible eliminar el programa."
    end
  end

  def novedades_empleados
    @epidemiological_surveillance_program = EpidemiologicalSurveillanceProgram.includes(:surveillance_configuration).find(params[:id])

    if @epidemiological_surveillance_program.surveillance_configuration.present?
      @events = Event.joins(detail_disease: :surveillance_configuration).includes(:user, :detail_disease, detail_disease: :surveillance_configuration).where(entity_id: @epidemiological_surveillance_program.entity_id, surveillance_configurations: {id: @epidemiological_surveillance_program.surveillance_configuration_id}).order(date_new: :desc)
    else
      @events = Event.none
    end
  end
  
  private

  def set_epidemiological_surveillance_program
    @epidemiological_surveillance_program = EpidemiologicalSurveillanceProgram.find(params[:id])
  end

  def epidemiological_surveillance_program_params
    params.require(:epidemiological_surveillance_program).permit(
      :entity_id,
      :surveillance_configuration_id,
      :code,
      :name,
      :description,
      :objective,
      :start_date,
      :end_date,
      :status,
      :responsible_id
    )
  end

end