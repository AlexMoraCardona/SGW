class LevelsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @levels = Level.all 
        else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
    end    

    def new
      @level = Level.new  
    end    

    def create
        @level = Level.new(level_params)

        if @level.save then
            redirect_to levels_path, notice: t('.created') 
        else
            render :new, levels: :unprocessable_entity
        end    
    end    
 
    def edit
        @level = Level.find(params[:id])
    end
    
    def update
        @level = Level.find(params[:id])
        if @level.update(level_params)
            redirect_to levels_path, notice: 'Nivel actualizado correctamente'
        else
            render :edit, status: :unprocessable_entity
        end         
    end    

    def destroy
        @level = Level.find(params[:id])
        @level.destroy
        redirect_to levels_path, notice: 'Nivel borrado correctamente', level: :see_other
    end    

    private

    def level_params
        params.require(:level).permit(:name)
    end 

end    