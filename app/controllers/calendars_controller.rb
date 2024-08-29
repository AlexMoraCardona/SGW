class CalendarsController < ApplicationController
    def index
        if  Current.user 
            @calendars = Calendar.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')    
             session.delete(:user_id)  
         end          
         
    end    

    def new
      @calendar = Calendar.new  
    end    

    def create
        @calendar = Calendar.new(calendar_params)

        if @calendar.save then
            redirect_to calendars_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @calendar = Calendar.find(params[:id])
    end
    
    def update
        @calendar = Calendar.find(params[:id])
        if @calendar.update(calendar_params)
            redirect_to calendars_path, notice: 'Calendario actualizado correctamente'
        else
            render :edit, calendars: :unprocessable_entity
        end         
    end  
    
    def show
       @adm_calendar = AdmCalendar.find_by(year: params[:id]) 
       @calendars = Calendar.where("adm_calendar_id = ?", @adm_calendar.id).order(:month, :day) if @adm_calendar.present?
    end    

    def destroy
        @calendar = Calendar.find(params[:id])
        @calendar.destroy
        redirect_to calendars_path, notice: 'Calendario borrado correctamente', calendar: :see_other
    end    

    def detail
        @calendar = Calendar.find(params[:id])
        @activities = Activity.where("calendar_id = ?", @calendar.id).order(:citation) if @calendar.present? 
        @activity_users = ActivityUser.all
    end  
    
    def nueva_actividad
        @activity = Activity.new
    end

    def seleccion
            @activity = Activity.find(params[:id])
            @users = User.where("entity = ? or level = ?", @activity.entity_id, 1)
    end 

    def citar
        vector = params[:ids] 
        n = 0
        n = params[:ids].count if params[:ids].present?
        activity_id = params[:id].to_i
        activity = Activity.find(activity_id)
        if n > 0
            Calendar.crear_citar(n, activity_id, vector)
            redirect_to detail_path(activity.calendar.id), notice: 'Citación creada correctamente', calendar: :see_other
        else
            redirect_to detail_path(activity.calendar.id), status: :unprocessable_entity, alert: 'No se seleccionó ningun usuario.' 
        end    

    end    
    
    
    private

    def calendar_params
        params.require(:calendar).permit(:day, :month, :year, :festive, :name_day, :adm_calendar_id)
    end 

end  
