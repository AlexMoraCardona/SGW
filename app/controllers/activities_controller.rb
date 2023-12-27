class ActivitiesController < ApplicationController
    def index

        if  Current.user && Current.user.level == 1
            @activities = Activity.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end          
         
    end    

    def show
        @activity = Activity.find(params[:id])
        @calendar = Calendar.find(@activity.calendar_id) if @activity.present?
        @activity_users = ActivityUser.where("activity_id = ?", @activity.id) if @activity.present? 

    end

    def new
      @activity = Activity.new  
    end    

    def create
        @activity = Activity.new(activity_params)

        if @activity.save then
            redirect_to detail_path(@activity.calendar_id), notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @activity = Activity.find(params[:id])
    end
    
    def update 
        @activity = Activity.find(params[:id])
        if @activity.update(activity_params)
            redirect_to detail_path(@activity.calendar_id), notice: 'Actividad actualizada correctamente'
        else
            render :edit, activities: :unprocessable_entity
        end         
    end    

    def destroy
        @activity = Activity.find(params[:id])
        @activity.destroy
        redirect_to activities_path, notice: 'Actividad borrada correctamente', activity: :see_other
    end    

    private

    def activity_params
        params.require(:activity).permit(:origin, :state, :description, :observation, 
         :place, :notify, :calendar_id, :entity_id, :user_id, :citation)
    end 

end  
