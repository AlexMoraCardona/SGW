class ImprovementPlansController < ApplicationController
    def index 
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            if params[:entity_id].present?
                @entity = Entity.find(params[:entity_id])
                @improvement_plans = ImprovementPlan.where("entity_id = ?", params[:entity_id]).order(id: :desc)
                @improvement_items = ImprovementItem.all
            else 
                @entities = Entity.all
            end    
        elsif Current.user && Current.user.level == 3 
            @entity = Entity.find(Current.user.entity)
            @improvement_plans = ImprovementPlan.where("entity_id = ?",Current.user.entity)
            @improvement_items = ImprovementItem.all
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end  
    
    def show 
        @improvement_plan = ImprovementPlan.find(params[:id])
        @entity = Entity.find(@improvement_plan.entity_id) if @improvement_plan.present?
        @rep = User.find(@improvement_plan.user_representante)
        @template = Template.where("reference = ? and version = ?",@improvement_plan.code,@improvement_plan.version).last  
        @template_versions = Template.where(reference: @template.reference, standar_detail_item_id: @template.standar_detail_item_id).order(:date, :version) if @template.present?

        @improvement_items = ImprovementItem.where("improvement_plan_id = ?", @improvement_plan.id) if @improvement_plan.present?
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end  
    
    def ver_improvement_plan_pdf
        @improvement_plan = ImprovementPlan.find(params[:id])
        @improvement_items = ImprovementItem.where("improvement_plan_id = ?", @improvement_plan.id) if @improvement_plan.present?
        @entity = Entity.find(@improvement_plan.entity_id) if @improvement_plan.present?
        @rep = User.find(@improvement_plan.user_representante)
        @template = Template.where("reference = ? and version = ?",@improvement_plan.code,@improvement_plan.version).last  
        @template_versions = Template.where(reference: @template.reference, standar_detail_item_id: @template.standar_detail_item_id).order(:date, :version) if @template.present?
        
        nombre_archivo = @template.reference.to_s + '.pdf'
        respond_to do |format| 
            format.html
            format.pdf {header_html = render_to_string( partial: 'templates/header')
                pdf = WickedPdf.new.pdf_from_string(
                    render_to_string('ver_improvement_plan_pdf'),
                    disable_javascript: true,
                    orientation: 'Landscape',
                    margin: {top: 50, bottom: 10, left: 5, right: 5 },
                    page_size: 'letter',
                    header: {spacing: 5,
                    content: header_html}
                )  
                send_data(pdf, filename: nombre_archivo, disposition: 'attachment')      
            }
        end    
      
    end    


    def new
      @improvement_plan =  ImprovementPlan.new
      @template = Template.where("reference = ? and document_vigente = ?",'PM-SST',1).last  

    end    

    def create
        @improvement_plan = ImprovementPlan.new(improvement_plan_params)
        if @improvement_plan.save then
            redirect_to improvement_plans_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @improvement_plan = ImprovementPlan.find(params[:id])
    end
    
    def update 
        @improvement_plan = ImprovementPlan.find(params[:id])
        if @improvement_plan.update(improvement_plan_params)
            actualizar_fecha(@improvement_plan.id)
            redirect_to improvement_plan_path(@improvement_plan.id), notice: 'Plan de mejoramiento actualizado correctamente'
        else
            render :edit, improvement_plans: :unprocessable_entity
        end         
    end    

    def destroy
        @improvement_plan = ImprovementPlan.find(params[:id])
        @improvement_plan.destroy
        redirect_to improvement_plans_path, notice: 'Plan de mejoramiento borrado correctamente', improvement_plan: :see_other
    end  

    def actualizar_fecha(id)
        @improvement_plan = ImprovementPlan.find(id)
        @improvement_plan.date_firm_representante = nil if @improvement_plan.firm_representante.to_i == 0
        @improvement_plan.date_firm_responsible = nil if @improvement_plan.firm_responsible.to_i == 0
        @improvement_plan.save
    end        
     
    def crear_item_improvement_plan 
        @improvement_item = ImprovementItem.new  
        @improvement_items = ImprovementItem.where("improvement_plan_id = ?", params[:id]) if params[:id].present?
        evaluation = Evaluation.find_by(entity_id: Current.user.entity)
        @standar_detail_items = EvaluationRuleDetail.where("evaluation_id = ?",evaluation.id) if evaluation.present?
        
        if @standar_detail_items.present?
            @standar_detail_items.each  do |standar_detail_item|
                if standar_detail_item.item_nro.blank?
                    standar_detail_item.item_nro = standar_detail_item.standar_detail_item.item_nro
                    standar_detail_item.save
                end    
            end    
        end    
    end    

    def firmar_representante_improvement 
        @improvement_plan = ImprovementPlan.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @improvement_plan.user_representante.to_i == Current.user.id.to_i 
                redirect_to firmar_representante_improvement_plan_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    def firmar_responsable_improvement
        @improvement_plan = ImprovementPlan.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @improvement_plan.user_responsible.to_i == Current.user.id.to_i 
                redirect_to firmar_responsable_improvement_plan_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable SG-SST."
            end    
        end
    end    


    private

    def improvement_plan_params
        params.require(:improvement_plan).permit(:user_representante, :user_responsible, :date_firm_representante, :date_firm_responsible, :firm_representante, :firm_responsible, :date_plan, :entity_id, :version, :code)
    end 
end 

