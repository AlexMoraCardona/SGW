class RiskLevelsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @risk_levels = RiskLevel.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new
      @risk_level = RiskLevel.new  
    end    

    def create
        @risk_level = RiskLevel.new(risk_level_params)

        if @risk_level.save then
            redirect_to risk_levels_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @risk_level = RiskLevel.find(params[:id])
    end
    
    def update
        @risk_level = RiskLevel.find(params[:id])
        if @risk_level.update(risk_level_params)
            redirect_to risk_levels_path, notice: 'Nivel de riesgo actualizado correctamente'
        else
            render :edit, risk_levels: :unprocessable_entity
        end         
    end    

    def destroy
        @risk_level = RiskLevel.find(params[:id])
        @risk_level.destroy
        redirect_to risk_levels_path, notice: 'Nivel de riesgo borrado correctamente', risk_level: :see_other
    end     

    private

    def risk_level_params
        params.require(:risk_level).permit(:name, :description )
    end 

end  