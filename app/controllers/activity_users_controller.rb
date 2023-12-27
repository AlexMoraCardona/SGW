class ActivityUsersController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @activity_users = ActivityUser.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end          
         
    end    

    def new
      @activity_user = ActivityUser.new  
    end    

    
    def create
        @activity_user = ActivityUser.new(activity_user_params)

        if @activity_user.save then
            redirect_to detail_path(@activity_user.activity.calendar.id), notice: 'Citación creada correctamente', calendar: :see_other
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @activity_user = ActivityUser.find(params[:id])
    end
    
    def update
        @activity_user = ActivityUser.find(params[:id])
        if @activity_user.update(activity_user_params)
            redirect_to detail_path(@activity_user.activity.calendar.id), notice: 'Usuario actualizado correctamente'
        else
            render :edit, activity_users: :unprocessable_entity
        end         
    end    

    def destroy
        @activity_user = ActivityUser.find(params[:id])
        @activity_user.destroy
        redirect_to detail_path(@activity_user.activity.calendar.id), notice: 'Usuario borrado correctamente', activity_user: :see_other
    end    

    private

    def activity_user_params
        params.require(:activity_user).permit(:mandatory, :attended, :confirm, :date_confirm, :activity_id, :user_id)
    end 

end  
