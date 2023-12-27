class AdmCalendarsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @adm_calendars = AdmCalendar.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end          
         
    end    

    def new
      @adm_calendar = AdmCalendar.new  
    end    

    def create
        @adm_calendar = AdmCalendar.new(adm_calendar_params)

        if @adm_calendar.save then
            redirect_to adm_calendars_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @adm_calendar = AdmCalendar.find(params[:id])
    end
    
    def update
        @adm_calendar = AdmCalendar.find(params[:id])
        if @adm_calendar.update(adm_calendar_params)
            redirect_to adm_calendars_path, notice: 'Admin. Calendario actualizado correctamente'
        else
            render :edit, adm_calendars: :unprocessable_entity
        end         
    end    

    def destroy
        @adm_calendar = AdmCalendar.find(params[:id])
        @adm_calendar.destroy
        redirect_to adm_calendars_path, notice: 'Admin. Calendario borrado correctamente', adm_calendar: :see_other
    end 
    
    def generar
        @adm_calendar = AdmCalendar.find(params[:id]) if params[:id].present?
        if @adm_calendar.generated == 0
           Calendar.crear(@adm_calendar) 
           @adm_calendar.generated = 1
           @adm_calendar.save
           redirect_to adm_calendars_path, notice: 'Calendario creado correctamente'
        else
            redirect_to adm_calendars_path, alert: 'Calendario ya fue creado', adm_calendar: :see_other
        end    
    end   
    
    def ver_calendario
        @adm_calendar = AdmCalendar.find(params[:id]) if params[:id].present?
        @calendars = Calendar.where("adm_calendar_id = ?", @adm_calendar.id).order(:month, :day) if @adm_calendar.present?
        
    end    

    private

    def adm_calendar_params
        params.require(:adm_calendar).permit(:year, :bisiesto, :day_initial, :generated)
    end 

end  
