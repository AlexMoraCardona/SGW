class EventsController < ApplicationController
    def index
        if  Current.user && Current.user.level > 0 && Current.user.level < 4
            #@events = Event.all
            if Current.user.level == 1 || Current.user.level == 2  
                @todos = Event.where("entity_id = ?",Current.user.entity).order(date_new: :desc)
                @q = @todos.ransack(params[:q]) 
                @pagy, @events = pagy(@q.result(date: :desc), items: 3)
            else 
                @todos = Event.where("entity_id = ?",Current.user.entity).order(date_new: :desc)
                @q = @todos.ransack(params[:q]) 
                @pagy, @events = pagy(@q.result(date: :desc), items: 3)
            end

         else
             redirect_to new_session_path, alert: t('common.not_logged_in')   
             session.delete(:user_id)   
         end           
         
    end  

    def show
      @event = Event.find(params[:id]).decorate  
    end    

    def new
      @event = Event.new  
      @sve_diseases = DetailDisease.joins(:surveillance_configuration).includes(:surveillance_configuration).order(:name)
    end    

    def create
        @event = Event.new(event_params)

        if @event.save then
            redirect_to events_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @event = Event.find(params[:id])
        @sve_diseases = DetailDisease.joins(:surveillance_configuration).includes(:surveillance_configuration).order(:name)
    end
    
    def update
        @event = Event.find(params[:id])
        if @event.update(event_params)
            redirect_to events_path, notice: 'Reporte actualizado correctamente'
        else
            render :edit, events: :unprocessable_entity
        end         
    end    

    def destroy
        @event = Event.find(params[:id])
        @event.destroy
        redirect_to events_path, notice: 'Reporte borrado correctamente', event: :see_other
    end  
    
    def new_sve_case
        @event = Event.find(params[:id])
        # Si ya existe un caso SVE para este evento,
        # evitamos crear otro
        if @event.epidemiological_surveillance_case.present?
            redirect_to event_path(@event), alert: "Este evento ya tiene un caso SVE asociado."
            return
        end
        # Solo programas activos de la misma empresa
        @epidemiological_surveillance_programs = EpidemiologicalSurveillanceProgram.where(entity_id: @event.entity_id, status: :active).order(:name)
    end

    def create_sve_case
        @event = Event.find(params[:id])
        # Evitar duplicar casos
        if @event.epidemiological_surveillance_case.present?
            redirect_to event_path(@event), alert: "Este evento ya tiene un caso SVE asociado."
            return
        end
        @epidemiological_surveillance_program = EpidemiologicalSurveillanceProgram.where(entity_id: @event.entity_id, status: :active).find(params[:epidemiological_surveillance_program_id])
        ActiveRecord::Base.transaction do
            @epidemiological_surveillance_case = EpidemiologicalSurveillanceCase.create!(epidemiological_surveillance_program: @epidemiological_surveillance_program, entity_id: @event.entity_id, user_id: @event.user_id, source_type: :event, event_id: @event.id, opened_at: Time.current, status: :identified, responsible_id: @epidemiological_surveillance_program.responsible_id, observations: "Caso creado a partir del evento ##{@event.id}.")
            EpidemiologicalSurveillanceCaseHistory.create!(epidemiological_surveillance_case: @epidemiological_surveillance_case, user: Current.user, previous_status: nil, new_status: EpidemiologicalSurveillanceCase.statuses[:identified], changed_at: Time.current, observations: "Caso creado a partir del evento ##{@event.id}.")
        end

        redirect_to(epidemiological_surveillance_program_epidemiological_surveillance_case_path(@epidemiological_surveillance_program, @epidemiological_surveillance_case), notice: "El caso SVE fue creado correctamente a partir del evento ##{@event.id}.")

        rescue ActiveRecord::RecordNotFound
            redirect_to(event_path(@event), alert: "El programa SVE seleccionado no es válido.")

        rescue ActiveRecord::RecordInvalid
            redirect_to(event_path(@event), alert: "No fue posible crear el caso SVE.")

    end    

    private

    def event_params 
        params.require(:event).permit(:date_new, :work_accident, :disability_start_date, 
        :disability_end_date, :mortal_accident, :occupational_disease, :laboral_inhability, 
        :common_inhability, :days_absenteeism, :user_reports, :user_id, :entity_id, :affected_body, :type_injure, :accident_agent, :accident_mechanism, :name_disease, :detail_disease_id, :continuous)
    end 

end 

