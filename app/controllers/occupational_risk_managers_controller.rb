class OccupationalRiskManagersController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @occupational_risk_managers = OccupationalRiskManager.all.decorate 
        else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           

    end    

    def new
      @occupational_risk_manager = OccupationalRiskManager.new  
    end    

    def create
        @occupational_risk_manager = OccupationalRiskManager.new(occupational_risk_manager_params)

        if @occupational_risk_manager.save then
            redirect_to occupational_risk_managers_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @occupational_risk_manager = OccupationalRiskManager.find(params[:id])
    end
    
    def update
        @occupational_risk_manager = OccupationalRiskManager.find(params[:id])
        if @occupational_risk_manager.update(occupational_risk_manager_params)
            redirect_to occupational_risk_managers_path, notice: 'ARL actualizada correctamente'
        else
            render :edit, occupational_risk_managers: :unprocessable_entity
        end         
    end    

    def destroy
        @occupational_risk_manager = OccupationalRiskManager.find(params[:id])
        @occupational_risk_manager.destroy
        redirect_to occupational_risk_managers_path, notice: 'ARL borrada correctamente', document: :see_other
    end    

    private

    def occupational_risk_manager_params
        params.require(:occupational_risk_manager).permit(:name, :code, :condition )
    end 

end  