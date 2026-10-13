class InternalReportsController < ApplicationController
    def index 
        if Current.user && Current.user.level > 0 && Current.user.level < 4 
            @entity = Entity.find(Current.user.entity)
            @internal_reports = InternalReport.where("entity_id = ?",@entity.id).order(id: :desc)
        else
            if Current.user && Current.user.level > 3 && Current.user.level < 6 
                @entity = Entity.find(Current.user.entity)
                @internal_reports = InternalReport.where("entity_id = ?",@entity.id).order(id: :desc)
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')    
                session.delete(:user_id)  
            end 
        end        
    end  
    
    def show
        @internal_report = InternalReport.find(params[:id])
        @entity = Entity.find(@internal_report.entity_id) if @internal_report.present?
        @usuario = User.find(@internal_report.user) if @internal_report.user.present? && @internal_report.user > 0
        @template = Template.where("reference = ? and version = ?",@internal_report.code,@internal_report.version).last  
        @template_versions = Template.where(reference: @template.reference, standar_detail_item_id: @template.standar_detail_item_id).order(:date, :version) if @template.present?


        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="ReporteInterno.xlsx"'
            }
        end    
    end  
    
    def ver_reporte_interno
        @internal_report = InternalReport.find(params[:id])
        @entity = Entity.find(@internal_report.entity_id) if @internal_report.present?
        @usuario = User.find(@internal_report.user) if @internal_report.user.present? && @internal_report.user > 0
        @template = Template.where("reference = ? and version = ?",@internal_report.code,@internal_report.version).last  
        @template_versions = Template.where(reference: @template.reference, standar_detail_item_id: @template.standar_detail_item_id).order(:date, :version) if @template.present?

        nombre_archivo = @template.reference.to_s + '.pdf'
        respond_to do |format| 
            format.html
            format.pdf {header_html = render_to_string( partial: 'templates/header')
                pdf = WickedPdf.new.pdf_from_string(
                    render_to_string('ver_reporte_interno'),
                    disable_javascript: true,
                    margin: {top: 50, bottom: 10, left: 5, right: 5 },
                    page_size: 'letter',
                    header: {spacing: 5,
                    content: header_html}
                )  
                send_data(pdf, filename: nombre_archivo, disposition: 'attachment')      
            }
        end    
     
    end  
    
    def firma_internal_report
        @internal_report = InternalReport.find(params[:id])
        @internal_report.date_user =  Time.now
        @internal_report.firm_user = 1
        
        if Current.user.id == @internal_report.user
            if @internal_report.save then
                redirect_to internal_report_path(@internal_report.id), notice: "Firmado correctamente!"
            else
                redirect_to internal_reports_path, alert: "Se produjo un error en la firma." 
            end
        else
            redirect_to  internal_reports_path, alert: "Su usuario no corresponde con el nombre de la firma." 
        end    

    end    
    

 
    def new
      @internal_report =  InternalReport.new
      @entity = Entity.find(Current.user.entity)
      @template = Template.where("reference = ? and document_vigente = ?",'RIAI-SST',1).last  
    end    

    def create
        @internal_report = InternalReport.new(internal_report_params)
        if @internal_report.save then
            redirect_to internal_reports_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
          @internal_report = InternalReport.find(params[:id])
          @entity = Entity.find(@internal_report.entity_id)
          @template = Template.where("reference = ? and version = ?",@internal_report.code,@internal_report.version).last  
    end
    
    def update
        @internal_report = InternalReport.find(params[:id])
        if @internal_report.update(update_internal_report_params)
            redirect_to internal_reports_path, notice: 'Reporte interno actualizado correctamente'
        else
            render :edit, internal_reports: :unprocessable_entity
        end         
    end    

    def destroy
        @internal_report = InternalReport.find(params[:id])
        @internal_report.destroy
        redirect_to internal_reports_path, notice: 'Reporte interno borrado correctamente', internal_report: :see_other
    end  


    private

    def internal_report_params
        params.require(:internal_report).permit(:date_report, :type_report, :time_report,
         :place, :description, :name_person, :user, :date_user, :version, :code, :firm_user, :entity_id, :state_report, 
         imagenes_reports: [])
    end 

    def update_internal_report_params
        params.require(:internal_report).permit(:date_report, :type_report, :time_report,
         :place, :description, :name_person, :date_user, :firm_user, :entity_id, :version, :code, :state_report, 
         imagenes_reports: [])
    end 

end  
