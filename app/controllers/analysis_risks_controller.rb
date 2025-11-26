class AnalysisRisksController < ApplicationController
    def index 
        if Current.user && Current.user.level > 0 && Current.user.level < 4 
            @entity = Entity.find(Current.user.entity)
            @analysis_risks = AnalysisRisk.where("entity_id = ?",Current.user.entity).order(id: :desc)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end  
    
    def show
        @analysis_risk = AnalysisRisk.find(params[:id])
        @entity = Entity.find(@analysis_risk.entity_id) if @analysis_risk.present?
        @template = Template.where("format_number = ? and document_vigente = ?",110,1).last  
        @analysis_risk_items = AnalysisRiskItem.where("analysis_risk_id = ?",@analysis_risk.id) if @analysis_risk.present?   
        @user = User.find(@analysis_risk.user_elaborated) if @analysis_risk.user_elaborated > 0
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Analisis.xlsx"'
            }
        end    
    end  
    
  
    def new
      @analysis_risk =  AnalysisRisk.new
      @entity = Entity.find(Current.user.entity)
      @template = Template.where("format_number = ? and document_vigente = ?",110,1).last  
      @protection_elements = ProtectionElement.where("(entity = ? or entity = ?) and state_protection = ?",6,Current.user.entity,1)
      @company_areas = CompanyArea.where("entity_id = ?",Current.user.entity.to_i) if Current.user.entity.present?
    end    

    def create
        @analysis_risk = AnalysisRisk.new(analysis_risk_params)
        user = User.find(@analysis_risk.user_elaborated) if @analysis_risk.user_elaborated > 0
        @analysis_risk.history = user.cargo_rol if user.present?

        if params[:epp_requested].present?
            epps = ''
            params[:epp_requested].each do |dato|
                epp = ProtectionElement.find(dato) if dato.present?
                if epp.present?
                    epps << epp.name + ", "
                end    
            end
            @analysis_risk.epp_requested =  epps if epps.present?
        end    

        if @analysis_risk.save then
            redirect_to analysis_risk_path(@analysis_risk.id), notice: 'Análisis de riesgo por oficio creado correctamente!' 
        else
            redirect_to analysis_risks_path, alert: 'Se presento error en la creación.' 
        end    
    end    
 
    def edit
          @analysis_risk = AnalysisRisk.find(params[:id])
          @entity = Entity.find(@analysis_risk.entity_id)
          @template = Template.where("format_number = ? and document_vigente = ?",110,1).last  
          @protection_elements = ProtectionElement.where("(entity = ? or entity = ?) and state_protection = ?",6,Current.user.entity,1)
          @company_areas = CompanyArea.where("entity_id = ?",Current.user.entity.to_i) if Current.user.entity.present?
    end
    
    def update
        @analysis_risk = AnalysisRisk.find(params[:id])
        if params[:epp_requested].present?
            epps = ''
            params[:epp_requested].each do |dato|
                epp = ProtectionElement.find(dato) if dato.present?
                if epp.present?
                    epps << epp.name + ", "
                end    
            end
            @analysis_risk.epp_requested =  epps if epps.present?
        end    
        
        if @analysis_risk.update(analysis_risk_params)
            redirect_to analysis_risk_path(@analysis_risk.id), notice: 'Análisis actualizado correctamente'
        else
            redirect_to analysis_risk_path(@analysis_risk.id), analysis_risks: :unprocessable_entity
        end         
    end    

    def destroy
        @analysis_risk = AnalysisRisk.find(params[:id])
        @analysis_risk.destroy
        redirect_to analysis_risks_path, notice: 'Análisis borrado correctamente', analysis_risk: :see_other
    end  

    
    def ver_analysis_risk
        @analysis_risk = AnalysisRisk.find(params[:id])
        @entity = Entity.find(@analysis_risk.entity_id) if @analysis_risk.present?
        @template = Template.where("format_number = ? and document_vigente = ?",110,1).last  
        @analysis_risk_items = AnalysisRiskItem.where("analysis_risk_id = ?",@analysis_risk.id) if @analysis_risk.present?   
        @user = User.find(@analysis_risk.user_elaborated) if @analysis_risk.user_elaborated > 0

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_analysis_risk',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                zoom: 0.75,
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
                       } 
        end
      
    end    

    def firma_analisis
        @analysis_risk = AnalysisRisk.find(params[:id])
        @analysis_risk.date_user_elaborated =  Time.now
        @analysis_risk.firm_user_elaborated = 1
        
        if Current.user.id == @analysis_risk.user_elaborated
            if @analysis_risk.save then
                redirect_to analysis_risk_path(@analysis_risk.id), notice: "Firmado correctamente!"
            else
                redirect_to analysis_risks_path, alert: "Se produjo un error en la firma." 
            end
        else
            redirect_to  analysis_risks_path, alert: "Su usuario no corresponde con el nombre de la firma." 
        end    

    end    

    def crear_item_paso
        @analysis_risk_item = AnalysisRiskItem.new
        @analysis_risk = AnalysisRisk.find(params[:id].to_i)  
    end    


    private

    def analysis_risk_params
        params.require(:analysis_risk).permit(:date_analysis, :code_area, 
        :description_activity, :routine_activity, :epp_requested, :accident, 
        :history, :tools_use, :training_activity, :activity_standar, :observations, 
        :user_elaborated, :date_user_elaborated, :firm_user_elaborated, :entity_id)
    end 

end  
   




