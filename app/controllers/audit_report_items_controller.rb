class AuditReportItemsController < ApplicationController
    def index 
        if  Current.user && Current.user.level == 1
            @audit_report_items = AuditReportItem.all
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')   
            session.delete(:user_id)   
        end           
    end  
    
    def new
      @audit_report_item = AuditReportItem.new  
    end    

    def create
        @audit_report_item = AuditReportItem.new(audit_report_item_params)

        if @audit_report_item.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @audit_report_item = AuditReportItem.find(params[:id])
    end
    
    def update
        @audit_report_item = AuditReportItem.find(params[:id])
        @audit_report = AuditReport.find(@audit_report_item.audit_report_id) if @audit_report_item.present?

        if @audit_report_item.update(audit_report_item_params)
            redirect_to audit_reports_path(entity_id: @audit_report.entity_id), notice: t('.created')
        else
            render :edit, audit_reports: :unprocessable_entity
        end         
    end    

    def destroy
        @audit_report_item = AuditReportItem.find(params[:id])
        @audit_report_item.destroy
        redirect_to audit_report_items_path, notice: 'Hallazgo borrado correctamente', audit_report_item: :see_other
    end    

    private

    def audit_report_item_params
        params.require(:audit_report_item).permit(:process, :finding, :type_finding, :audit_report_id, :type_action, finding_evidences: [] )
    end  

end  




