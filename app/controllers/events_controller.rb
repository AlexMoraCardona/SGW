class EventsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            #@events = Event.all
            @q = Event.ransack(params[:q])
            @pagy, @events = pagy(@q.result(date: :desc), items: 3)

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

    private

    def event_params
        params.require(:event).permit(:date_new, :work_accident, :disability_start_date, 
        :disability_end_date, :mortal_accident, :occupational_disease, :laboral_inhability, 
        :common_inhability, :days_absenteeism, :user_reports, :user_id, :entity_id )
    end 

end 

