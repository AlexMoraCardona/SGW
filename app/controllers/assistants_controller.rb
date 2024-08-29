class AssistantsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @assistants = Assistant.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')  
             session.delete(:user_id)    
         end           
         
    end    

    def new
      @assistant = Assistant.new  
    end    

    def create
        @assistant = Assistant.new(assistant_params)
        if @assistant.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end     
    end    
 
    def edit
        @assistant = Assistant.find(params[:id])
    end
    
    def update
        @assistant = Assistant.find(params[:id])
        if @assistant.update(assistant_params)
            redirect_back fallback_location: root_path, notice: 'Firma asistente actualizado correctamente'
        else
            render :edit, assistants: :unprocessable_entity
        end         
    end    

    def destroy
        @assistant = Assistant.find(params[:id])
        @assistant.destroy
        redirect_back fallback_location: root_path, notice: 'Firma asistente borrada correctamente', assistant: :see_other
    end    

    private  
       
    def assistant_params
        params.require(:assistant).permit(:name, :post, :meeting_minute_id)
    end
end    


