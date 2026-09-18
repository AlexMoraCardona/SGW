class ChangeManagementsController < ApplicationController
    def index 
        if Current.user && Current.user.level > 0 && Current.user.level < 4 
            @entity = Entity.find(Current.user.entity)
            @change_managements = ChangeManagement.where("entity_id = ?",Current.user.entity).order(id: :desc)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end  
    
    def show
        @change_management = ChangeManagement.find(params[:id])
        @entity = Entity.find(@change_management.entity_id) if @change_management.present?
        @change_management_items = ChangeManagementItem.where("change_management_id = ?",@change_management.id) if @change_management.present?   
        @user = User.find(@change_management.user_elaborated) if @change_management.user_elaborated > 0
        @template = Template.where("reference = ? and version = ?",@change_management.code,@change_management.version).last  
        @template_versions = Template.where(reference: @template.reference, standar_detail_item_id: @template.standar_detail_item_id).order(:date, :version) if @template.present?


        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Analisis.xlsx"'
            }
        end    
    end  
    
  
    def new
      @change_management =  ChangeManagement.new
      @entity = Entity.find(Current.user.entity)
      @company_areas = CompanyArea.where("entity_id = ?",Current.user.entity.to_i) if Current.user.entity.present?
      @template = Template.where("reference = ? and document_vigente = ?",'GC-SST',1).last  

    end    

    def create
        @change_management = ChangeManagement.new(change_management_params)
        user = User.find(@change_management.user_elaborated) if @change_management.user_elaborated > 0

        if params[:change_management][:dangers_change].present?
            dangers = ''
            params[:change_management][:dangers_change].each do |dato|
                danger =  ClasificationDangerDetail.find(dato) if dato.present?
                if danger.present?
                    dangers << ' *' + danger.clasification_danger.name + " - " + danger.name + ", "
                end    
            end
            @change_management.dangers_change =  dangers if dangers.present?
        end    

        if @change_management.save then
            redirect_to change_management_path(@change_management.id), notice: 'Análisis del impacto del sistema creado correctamente!' 
        else
            redirect_to change_managements_path, alert: 'Se presento error en la creación.' 
        end    
    end    
 
    def edit
          @change_management = ChangeManagement.find(params[:id])
          @entity = Entity.find(@change_management.entity_id)
          @template = Template.where("reference = ? and version = ?",@change_management.code,@change_management.version).last 
          @company_areas = CompanyArea.where("entity_id = ?",Current.user.entity.to_i) if Current.user.entity.present?
    end
    
    def update
        @change_management = ChangeManagement.find(params[:id])
        if params[:change_management][:dangers_change].present?
            dangers = ''
            params[:change_management][:dangers_change].each do |dato|
                danger =  ClasificationDangerDetail.find(dato) if dato.present?
                if danger.present?
                    dangers << ' *' + danger.clasification_danger.name + " - " + danger.name + ", "
                end    
            end
            @change_management.dangers_change =  dangers if dangers.present?
        end    
        
        if @change_management.update(change_management_params)
            redirect_to change_management_path(@change_management.id), notice: 'Análisis actualizado correctamente'
        else
            redirect_to change_management_path(@change_management.id), change_managements: :unprocessable_entity
        end         
    end    

    def destroy
        @change_management = ChangeManagement.find(params[:id])
        @change_management.destroy
        redirect_to change_managements_path, notice: 'Análisis borrado correctamente', change_management: :see_other
    end  

    
    def ver_analysis_cambio
        @change_management = ChangeManagement.find(params[:id])
        @entity = Entity.find(@change_management.entity_id) if @change_management.present?
        @change_management_items = ChangeManagementItem.where("change_management_id = ?",@change_management.id) if @change_management.present?   
        @user = User.find(@change_management.user_elaborated) if @change_management.user_elaborated > 0
        @template = Template.where("reference = ? and version = ?",@change_management.code,@change_management.version).last  
        @template_versions = Template.where(reference: @template.reference, standar_detail_item_id: @template.standar_detail_item_id).order(:date, :version) if @template.present?

        nombre_archivo = @template.reference.to_s + '.pdf'
        respond_to do |format| 
            format.html
            format.pdf {header_html = render_to_string( partial: 'templates/header')
                pdf = WickedPdf.new.pdf_from_string(
                    render_to_string('ver_analysis_cambio'),
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

    def firma_analisis_cambio
        @change_management = ChangeManagement.find(params[:id])
        @change_management.date_user_elaborated =  Time.now
        @change_management.firm_user_elaborated = 1
        
        if Current.user.id == @change_management.user_elaborated
            if @change_management.save then
                redirect_to change_management_path(@change_management.id), notice: "Firmado correctamente!"
            else
                redirect_to change_managements_path, alert: "Se produjo un error en la firma." 
            end
        else
            redirect_to  change_managements_path, alert: "Su usuario no corresponde con el nombre de la firma." 
        end    

    end    

    def crear_item_paso_cambio
        @change_management_item = ChangeManagementItem.new
        @change_management = ChangeManagement.find(params[:id].to_i)  
    end    


    private

    def change_management_params
        params.require(:change_management).permit(:date_change, :code_area,
         :description_change, :analisys_change, :recomendations_change,
          :dangers_change, :requeriment_legal, :operational_control, :work_procedure, 
          :others, :user_elaborated, :date_user_elaborated, :firm_user_elaborated, 
          :entity_id, :version, :code)
    end 

end  
   




