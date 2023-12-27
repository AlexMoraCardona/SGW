class ClasificationDangersController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @clasification_dangers = ClasificationDanger.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new
      @clasification_danger = ClasificationDanger.new  
    end    

    def create
        @clasification_danger = ClasificationDanger.new(clasification_danger_params)

        if @clasification_danger.save then
            redirect_to clasification_dangers_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @clasification_danger = ClasificationDanger.find(params[:id])
    end
    
    def update
        @clasification_danger = ClasificationDanger.find(params[:id])
        if @clasification_danger.update(clasification_danger_params)
            redirect_to clasification_dangers_path, notice: 'Clasificación de peligro o riesgo actualizado correctamente'
        else
            render :edit, clasification_dangers: :unprocessable_entity
        end         
    end    

    def destroy
        @clasification_danger = ClasificationDanger.find(params[:id])
        @clasification_danger.destroy
        redirect_to clasification_dangers_path, notice: 'Clasificación de peligro o riesgo borrado correctamente', clasification_danger: :see_other
    end    

    private

    def clasification_danger_params
        params.require(:clasification_danger).permit(:name)
    end 

end  
