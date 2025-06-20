class AuditReportsController < ApplicationController
    def index 
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            if params[:entity_id].present?
                @entity = Entity.find(params[:entity_id])
                @audit_reports = AuditReport.where("entity_id = ?", params[:entity_id]).order(id: :desc)
                @audit_report_items = AuditReportItem.all
            else 
                @entities = Entity.all
            end    
        elsif Current.user && Current.user.level > 2 && Current.user.level < 5 
            @entity = Entity.find(Current.user.entity)
            @audit_reports = AuditReport.where("entity_id = ?",Current.user.entity)
            @audit_report_items = AuditReportItem.all
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end 
    end  
    
    def show 
        @template = Template.where("format_number = ? and document_vigente = ?",70,1).last  
        @audit_report = AuditReport.find(params[:id])
        @entity = Entity.find(@audit_report.entity_id) if @audit_report.present?
        @user_audit = User.find(@audit_report.user_audit)
        @user_representante = User.find(@audit_report.user_representante)

        @audit_report_items = AuditReportItem.where("audit_report_id = ?", @audit_report.id) if @audit_report.present?
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end  
    
    def ver_auditoria_interna_pdf
        @audit_report = AuditReport.find(params[:id])
        @audit_report_items = AuditReportItem.where("audit_report_id = ?", @audit_report.id) if @audit_report.present?
        @template = Template.where("format_number = ? and document_vigente = ?",70,1).last  
        @entity = Entity.find(@audit_report.entity_id) if @audit_report.present?
        @user_audit = User.find(@audit_report.user_audit)
        @user_representante = User.find(@audit_report.user_representante)

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
      @audit_report =  AuditReport.new
      @template = Template.where("format_number = ? and document_vigente = ?",70,1).last  
    end    

    def create
        @audit_report = AuditReport.new(audit_report_params)
        if @audit_report.save then
            redirect_to audit_reports_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @audit_report = AuditReport.find(params[:id])
    end
    
    def update
        @audit_report = AuditReport.find(params[:id])
        if @audit_report.update(audit_report_params)
            actualizar_fecha(@audit_report.id)
            redirect_to audit_reports_path(entity_id: @audit_report.entity_id), notice: 'Auditoría interna actualizada correctamente'
        else
            render :edit, audit_reports: :unprocessable_entity
        end         
    end    

    def destroy
        @audit_report = AuditReport.find(params[:id])
        @audit_report.destroy
        redirect_to audit_reports_path, notice: 'Auditoría interna borrada correctamente', audit_report: :see_other
    end  

    def actualizar_fecha(id)
        @audit_report = AuditReport.find(id)
        @audit_report.date_firm_representante = nil if @audit_report.firm_representante.to_i == 0
        @audit_report.date_firm_audit = nil if @audit_report.firm_audit.to_i == 0
        @audit_report.save
    end      
     
    def crear_item_auditoria_interna 
        @audit_report_item = AuditReportItem.new   
        @audit_report_items = AuditReportItem.where("audit_report_id = ?", params[:id]) if params[:id].present?
        @standar_detail_items = StandarDetailItem.all.order(:item_nro)
    end    

    def firmar_representante 
        @audit_report = AuditReport.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @audit_report.user_representante.to_i == Current.user.id.to_i
                redirect_to firmar_representante_audi_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    def firmar_auditor
        @audit_report = AuditReport.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @audit_report.user_audit.to_i == Current.user.id.to_i
                redirect_to firmar_auditor_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Auditor."
            end    
        end
    end    


    private

    def audit_report_params
        params.require(:audit_report).permit(:user_representante, :user_audit, :date_firm_representante, :date_firm_audit, :firm_representante, :firm_audit, :entity_id, :date_audit, :conclusions, :observations)
    end 
end  

