class DangerDetailRisksController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            if params[:format].present?
                @danger_detail_risks = DangerDetailRisk.where("clasification_danger_detail_id = ?", params[:format])
            else
                @danger_detail_risks = DangerDetailRisk.all
            end    
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new
      @danger_detail_risk  = DangerDetailRisk.new  
    end    

    def create
        @danger_detail_risk = DangerDetailRisk.new(danger_detail_risk_params)

        if @danger_detail_risk.save then
            redirect_to edit_clasification_danger_detail_path(@danger_detail_risk.clasification_danger_detail_id), notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @danger_detail_risk = DangerDetailRisk.find(params[:id])
    end
    
    def update
        @danger_detail_risk = DangerDetailRisk.find(params[:id])
        if @danger_detail_risk.update(danger_detail_risk_params)
            redirect_to edit_clasification_danger_detail_path(@danger_detail_risk.clasification_danger_detail_id), notice: 'Posible riesgo actualizado correctamente'
        else
            render :edit, danger_detail_risks: :unprocessable_entity
        end         
    end    

    def destroy
        @danger_detail_risk = DangerDetailRisk.find(params[:id])
        @danger_detail_risk.destroy
        redirect_to edit_clasification_danger_detail_path(@danger_detail_risk.clasification_danger_detail_id), notice: 'Posible riesgo borrado correctamente', danger_detail_risk: :see_other
    end    

    private

    def danger_detail_risk_params
        params.require(:danger_detail_risk).permit(:name, :clasification_danger_detail_id)
    end 

end  
