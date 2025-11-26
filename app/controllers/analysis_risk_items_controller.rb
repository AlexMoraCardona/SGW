class AnalysisRiskItemsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @analysis_risk_items = AnalysisRiskItem.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')    
             session.delete(:user_id)  
         end           
         
    end    

    def new
      @analysis_risk_item = AnalysisRiskItem.new  
      @company_areas = CompanyArea.where("entity_id = ?",Current.user.entity.to_i) if Current.user.entity.present?
    end    

    def create
        @analysis_risk_item = AnalysisRiskItem.new(analysis_risk_item_params)
        if params[:analysis_risk_item][:risks_steps].present?
            risks = ''
            params[:analysis_risk_item][:risks_steps].each do |dato|
                risk = ClasificationDangerDetail.find(dato) if dato.present?
                if risk.present?
                    risks << ' *' + risk.clasification_danger.name + " - " + risk.name + ", "
                end    
            end
            @analysis_risk_item.risks_steps =  risks if risks.present?
        end    

        if @analysis_risk_item.save then
            redirect_to analysis_risk_path(@analysis_risk_item.analysis_risk_id), notice: 'Creado correctamente' 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @analysis_risk_item = AnalysisRiskItem.find(params[:id])
    end
    
    def update
        @analysis_risk_item = AnalysisRiskItem.find(params[:id])
        if params[:analysis_risk_item][:risks_steps].present?
            risks = ''
            params[:analysis_risk_item][:risks_steps].each do |dato|
                risk = ClasificationDangerDetail.find(dato) if dato.present?
                if risk.present?
                    risks << ' *' + risk.clasification_danger.name + " - " + risk.name + ", "
                end    
            end
            @analysis_risk_item.risks_steps =  risks if risks.present?
        end    

        if @analysis_risk_item.update(analysis_risk_item_params)
            redirect_to analysis_risk_path(@analysis_risk_item.analysis_risk_id), notice: 'Actualizado correctamente'
        else
            render :edit, analysis_risk_items: :unprocessable_entity
        end         
    end    

    def destroy
        @analysis_risk_item = AnalysisRiskItem.find(params[:id])
        @analysis_risk_item.destroy
        redirect_to analysis_risk_path(@analysis_risk_item.analysis_risk_id), notice: 'Investigador borrado correctamente', analysis_risk_item: :see_other
    end  
    

    private

    def analysis_risk_item_params
        params.require(:analysis_risk_item).permit(:basic_steps, :actions_steps, :risks_steps, :measures_steps, :analysis_risk_id)
    end 

end  
 


      