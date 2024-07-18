class SafetyInspectionsController < ApplicationController
    def index 
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @safety_inspections = SafetyInspection.where("entity_id = ?", params[:entity_id])
            @safety_inspection_items = SafetyInspectionItem.all
        else    
            if  Current.user && Current.user.level == 1
                @entities = Entity.all
                @safety_inspections = SafetyInspection.all
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')      
            end           
        end 
    end  
    
    def show 
        @template = Template.find(220)
        @safety_inspection = SafetyInspection.find(params[:id])
        @entity = Entity.find(@safety_inspection.entity_id) if @safety_inspection.present?
        @user_audit = User.find(@safety_inspection.user_audit)
        @user_representante = User.find(@safety_inspection.user_representante)

        @safety_inspection_items = SafetyInspectionItem.where("safety_inspection_id = ?", @safety_inspection.id) if @safety_inspection.present?
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end  
    
    def ver_auditoria_interna_pdf
        @safety_inspection = SafetyInspection.find(params[:id])
        @safety_inspection_items = SafetyInspectionItem.where("safety_inspection_id = ?", @safety_inspection.id) if @safety_inspection.present?
        @template = Template.find(211)
        @entity = Entity.find(@safety_inspection.entity_id) if @safety_inspection.present?
        @user_audit = User.find(@safety_inspection.user_audit)
        @user_representante = User.find(@safety_inspection.user_representante)

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_auditoria_interna',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
                       } 
        end
      
    end    


    def new
      @safety_inspection =  SafetyInspection.new
      @template = Template.find(211)
    end    

    def create
        @safety_inspection = SafetyInspection.new(safety_inspection_params)
        if @safety_inspection.save then
            redirect_to safety_inspections_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @safety_inspection = SafetyInspection.find(params[:id])
    end
    
    def update
        @safety_inspection = SafetyInspection.find(params[:id])
        if @safety_inspection.update(safety_inspection_params)
            actualizar_fecha(@safety_inspection.id)
            redirect_to safety_inspections_path(entity_id: @safety_inspection.entity_id), notice: 'Auditoría interna actualizada correctamente'
        else
            render :edit, safety_inspections: :unprocessable_entity
        end         
    end    

    def destroy
        @safety_inspection = SafetyInspection.find(params[:id])
        @safety_inspection.destroy
        redirect_to safety_inspections_path, notice: 'Auditoría interna borrada correctamente', safety_inspection: :see_other
    end  

    def actualizar_fecha(id)
        @safety_inspection = SafetyInspection.find(id)
        @safety_inspection.date_firm_representante = nil if @safety_inspection.firm_representante.to_i == 0
        @safety_inspection.date_firm_audit = nil if @safety_inspection.firm_audit.to_i == 0
        @safety_inspection.save
    end      
     
    def crear_item_auditoria_interna 
        @safety_inspection_item = SafetyInspectionItem.new  
        @safety_inspection_items = SafetyInspectionItem.where("safety_inspection_id = ?", params[:id]) if params[:id].present?
    end    

    def firmar_representante 
        @safety_inspection = SafetyInspection.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @safety_inspection.user_representante.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_representante_audi_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    def firmar_auditor
        @safety_inspection = SafetyInspection.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @safety_inspection.user_audit.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_auditor_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Auditor."
            end    
        end
    end    


    private

    def safety_inspection_params
        params.require(:safety_inspection).permit(:user_representante, :user_audit, :date_firm_representante, :date_firm_audit, :firm_representante, :firm_audit, :entity_id, :date_audit, :conclusions, :observations)
    end 
end  

