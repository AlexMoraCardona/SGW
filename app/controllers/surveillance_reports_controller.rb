class SurveillanceReportsController < ApplicationController

  before_action :set_epidemiological_surveillance_program

  before_action :set_surveillance_report,
              only: [
                :show,
                :edit,
                :update,
                :destroy,
                :autorizar_firma,
                :quitar_autorizacion_firma,
                :finalizar
              ]

  before_action :cargar_datos_automaticos,
              only: [
                :new,
                :edit,
                :create,
                :update,
                :show
              ]
  # ============================================================
  # NUEVO REPORTE
  # ============================================================

  def new
    @surveillance_report = @epidemiological_surveillance_program.surveillance_report

    unless @surveillance_report.present?
      @surveillance_report = @epidemiological_surveillance_program.build_surveillance_report
    end

    preparar_formulario
  end


  # ============================================================
  # CREAR REPORTE
  # ============================================================

  def create
    @surveillance_report = @epidemiological_surveillance_program.build_surveillance_report(surveillance_report_params)

    @surveillance_report.responsible_name = @responsible&.name
    @surveillance_report.responsible_position = @responsible_position&.name
    @surveillance_report.responsible_license =  @responsible&.license

    ActiveRecord::Base.transaction do
      @surveillance_report.save!
    end

    redirect_to(epidemiological_surveillance_program_path(@epidemiological_surveillance_program), notice: "El reporte SVE fue creado correctamente.")

    rescue ActiveRecord::RecordInvalid => e

    Rails.logger.error(
    "Error creando reporte SVE: " \
    "#{e.record.errors.full_messages.join(', ')}"
    )

    preparar_formulario

    @surveillance_report.errors.add(
    :base,
    "No fue posible guardar el reporte. " \
    "Verifique la información ingresada."
    )

    render :new, status: :unprocessable_entity
  end

  # ============================================================
  # MOSTRAR REPORTE
  # ============================================================

  def show
    cargar_datos_automaticos
  end


  # ============================================================
  # EDITAR REPORTE
  # ============================================================
  def edit
    cargar_datos_automaticos
  end

  # ============================================================
  # ACTUALIZAR REPORTE
  # ============================================================
  def update
    ActiveRecord::Base.transaction do
      @surveillance_report.update!(surveillance_report_params)
    end

    redirect_to(epidemiological_surveillance_program_surveillance_report_path(@epidemiological_surveillance_program), notice: "El reporte SVE fue actualizado correctamente.")


    rescue ActiveRecord::RecordInvalid => e

    Rails.logger.error(
      "Error actualizando reporte SVE: " \
      "#{e.record.errors.full_messages.join(', ')}"
    )

    preparar_formulario

    @surveillance_report.errors.add(
      :base,
      "No fue posible actualizar el reporte. " \
      "Verifique la información ingresada."
    )

    render :edit, status: :unprocessable_entity

  end


  # ============================================================
  # ELIMINAR REPORTE
  # ============================================================

  def destroy
    @surveillance_report.destroy!

    redirect_to(epidemiological_surveillance_program_path(@epidemiological_surveillance_program), notice: "El reporte SVE fue eliminado correctamente.")

    rescue ActiveRecord::RecordNotDestroyed => e

    Rails.logger.error(
      "Error eliminando reporte SVE: " \
      "#{e.record.errors.full_messages.join(', ')}"
    )

    redirect_to(epidemiological_surveillance_program_surveillance_report_path(@epidemiological_surveillance_program), alert: "No fue posible eliminar el reporte SVE.")

  end

  def autorizar_firma
    @surveillance_report.update!(autoriza_firma: true, fecha_firma: Date.current)

    redirect_to(epidemiological_surveillance_program_surveillance_report_path(@epidemiological_surveillance_program), notice: "La firma del responsable fue autorizada correctamente.")

    rescue ActiveRecord::RecordInvalid => e
    redirect_to(epidemiological_surveillance_program_surveillance_report_path(@epidemiological_surveillance_program), alert: "No fue posible autorizar la firma.")
  end

  def quitar_autorizacion_firma
    @surveillance_report.update!(autoriza_firma: false, fecha_firma: nil)

    redirect_to(epidemiological_surveillance_program_surveillance_report_path(@epidemiological_surveillance_program), notice: "La autorización de firma fue retirada.")

    rescue ActiveRecord::RecordInvalid
    redirect_to(epidemiological_surveillance_program_surveillance_report_path(@epidemiological_surveillance_program), alert: "No fue posible retirar la autorización de firma.")
  end

  def finalizar
    unless @surveillance_report.autoriza_firma?
      redirect_to(epidemiological_surveillance_program_surveillance_report_path(@epidemiological_surveillance_program), alert: "Debe autorizar la firma antes de finalizar el reporte.")
      return
    end

    @surveillance_report.update!(status: :finalized)

    redirect_to(epidemiological_surveillance_program_surveillance_report_path(@epidemiological_surveillance_program), notice: "El reporte SVE fue finalizado correctamente.")

    rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error(
      "Error finalizando reporte SVE: " \
      "#{e.record.errors.full_messages.join(', ')}"
    )

    redirect_to(epidemiological_surveillance_program_surveillance_report_path(@epidemiological_surveillance_program), alert: "No fue posible finalizar el reporte SVE.")
  end

  private


  # ============================================================
  # PROGRAMA SVE
  # ============================================================

  def set_epidemiological_surveillance_program
    @epidemiological_surveillance_program = EpidemiologicalSurveillanceProgram.find(params[:epidemiological_surveillance_program_id])
  end

  # ============================================================
  # REPORTE SVE
  # ============================================================
  def set_surveillance_report
    @surveillance_report = @epidemiological_surveillance_program.surveillance_report
    unless @surveillance_report.present?
      redirect_to(new_epidemiological_surveillance_program_surveillance_report_path(@epidemiological_surveillance_program), alert: "El reporte SVE aún no ha sido creado.")
    end
  end


  # ============================================================
  # DATOS AUTOMÁTICOS
  # ============================================================

  def cargar_datos_automaticos
    @entity = @epidemiological_surveillance_program.entity

    @responsible =  User.find_by(id: @epidemiological_surveillance_program.responsible_id)

    @responsible_position = CompanyPosition.find_by(id: @responsible&.activity)

    @economic_activity_code = EconomicActivityCode.find_by(id: @entity.economic_activity)

    @municipality = AdministrativePoliticalDivision.find_by(id: @entity.entity_location_code)&.municipality_name

    @legal_representative = [@entity.first_name_legal_representative, @entity.second_name_legal_representative, @entity.surname_legal_representative, @entity.second_surname_legal_representative].compact_blank.join(" ")
  
    # NIT con dígito de verificación
    @nit_empresa = [@entity.identification_number, @entity.verification_digit].compact_blank.join("-")

    # ARL
    @occupational_risk_manager = OccupationalRiskManager.find_by(id: @entity.entity_arl)
  end

  # ============================================================
  # PREPARAR FORMULARIO
  # ============================================================

  def preparar_formulario
    return unless @surveillance_report

    if @surveillance_report.surveillance_report_populations.empty?
      @surveillance_report.surveillance_report_populations.build
    end

    if @surveillance_report.surveillance_report_processes.empty?
      @surveillance_report.surveillance_report_processes.build
    end

    if @surveillance_report.surveillance_report_hazards.empty?
      @surveillance_report.surveillance_report_hazards.build
    end
  end


  # ============================================================
  # STRONG PARAMETERS
  # ============================================================

  def surveillance_report_params

    params
      .require(:surveillance_report)
      .permit(

        :responsible_name,
        :responsible_position,
        :responsible_license,
        :number_of_workers,
        :autoriza_firma,
        :fecha_firma,
        :status,

        # ------------------------------------------------------
        # POBLACIÓN OBJETO
        # ------------------------------------------------------

        surveillance_report_populations_attributes: [

          :id,
          :priority,
          :exposure,
          :number_exposed,
          :position,
          :_destroy

        ],

        # ------------------------------------------------------
        # PROCESOS PRODUCTIVOS
        # ------------------------------------------------------

        surveillance_report_processes_attributes: [

          :id,
          :process_name,
          :risks,
          :position,
          :_destroy

        ],

        # ------------------------------------------------------
        # AGENTES DE RIESGO
        # ------------------------------------------------------

        surveillance_report_hazards_attributes: [

          :id,
          :agent,
          :substance_product,
          :possible_effects,
          :position,
          :_destroy

        ]

      )

  end

end

