class InternalReportsController < ApplicationController
    def index 
        if Current.user && Current.user.level > 0 && Current.user.level < 4 
            @entity = Entity.find(Current.user.entity)
            @internal_reports = InternalReport.where("entity_id = ?",@entity.id)
        else
            if Current.user && Current.user.level > 3 && Current.user.level < 6 
                @entity = Entity.find(Current.user.entity)
                @internal_reports = InternalReport.where("entity_id = ?",@entity.id)
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')    
                session.delete(:user_id)  
            end 
        end        
    end  
    
    def show
        @internal_report = InternalReport.find(params[:id])
        @entity = Entity.find(@internal_report.entity_id) if @internal_report.present?
        @template = Template.where("format_number = ? and document_vigente = ?",115,1).last  
        @usuario = User.find(@internal_report.user) if @internal_report.user.present? && @internal_report.user > 0

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
        @template = Template.where("format_number = ? and document_vigente = ?",115,1).last  
        @usuario = User.find(@internal_report.user) if @internal_report.user.present? && @internal_report.user > 0

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_reporte_interno',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
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
      @template = Template.where("format_number = ? and document_vigente = ?",115,1).last  
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
          @template = Template.where("format_number = ? and document_vigente = ?",115,1).last  
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
         :place, :description, :name_person, :user, :date_user, :firm_user, :entity_id, :state_report, 
         imagenes_reports: [])
    end 

    def update_internal_report_params
        params.require(:internal_report).permit(:date_report, :type_report, :time_report,
         :place, :description, :name_person, :date_user, :firm_user, :entity_id, :state_report, 
         imagenes_reports: [])
    end 

end  
