class MockScriptsController < ApplicationController
    def index 
        if Current.user && Current.user.level > 0 && Current.user.level < 4 
            @entity = Entity.find(Current.user.entity)
            @mock_scripts = MockScript.where("entity_id = ?",Current.user.entity).order(id: :desc)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end  
    
    def show
        @mock_script = MockScript.find(params[:id])
        @entity = Entity.find(@mock_script.entity_id) if @mock_script.present?
        @user_asesor = User.find(@mock_script.user_asesor) if @mock_script.user_asesor > 0
        @user_representante = User.find(@mock_script.user_representante) if @mock_script.user_representante > 0
        @template = Template.where("reference = ? and version = ?",@mock_script.code,@mock_script.version).last  
        @template_versions = Template.where(reference: @template.reference, standar_detail_item_id: @template.standar_detail_item_id).order(:date, :version) if @template.present?

        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Analisis.xlsx"'
            }
        end    
    end  
    
  
    def new
      @mock_script =  MockScript.new
      @entity = Entity.find(Current.user.entity)
      @template = Template.where("reference = ? and document_vigente = ?",'GSE-SST',1).last  
      @user_asesor = User.find(@entity.external_consultant) if @entity.external_consultant > 0
      @user_representante = User.find_by(entity: @entity.id, legal_representative: 1) if @entity.present?
    end    

    def create
        @mock_script = MockScript.new(mock_script_params)

        if @mock_script.save then
            redirect_to mock_script_path(@mock_script.id), notice: 'Guión creado correctamente!' 
        else
            redirect_to mock_scripts_path, alert: 'Se presento error en la creación.' 
        end    
    end    
 
    def edit
          @mock_script = MockScript.find(params[:id])
          @entity = Entity.find(@mock_script.entity_id)
          @template = Template.where("reference = ? and version = ?",@mock_script.code,@mock_script.version).last  
    end
    
    def update
        @mock_script = MockScript.find(params[:id])
        
        if @mock_script.update(mock_script_params)
            redirect_to mock_script_path(@mock_script.id), notice: 'Guión actualizado correctamente'
        else
            redirect_to mock_script_path(@mock_script.id), mock_scripts: :unprocessable_entity
        end         
    end    

    def destroy
        @mock_script = MockScript.find(params[:id])
        @mock_script.destroy
        redirect_to mock_scripts_path, notice: 'Guión borrado correctamente', mock_script: :see_other
    end  

    
    def ver_mock_script
        @mock_script = MockScript.find(params[:id])
        @entity = Entity.find(@mock_script.entity_id) if @mock_script.present?
        @user_asesor = User.find(@mock_script.user_asesor) if @mock_script.user_asesor > 0
        @user_representante = User.find(@mock_script.user_representante) if @mock_script.user_representante > 0
        @template = Template.where("reference = ? and version = ?",@mock_script.code,@mock_script.version).last  
        @template_versions = Template.where(reference: @template.reference, standar_detail_item_id: @template.standar_detail_item_id).order(:date, :version) if @template.present?

        nombre_archivo = @template.reference.to_s + '.pdf'
        respond_to do |format| 
            format.html
            format.pdf {header_html = render_to_string( partial: 'templates/header')
                pdf = WickedPdf.new.pdf_from_string(
                    render_to_string('ver_mock_script'),
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

    def firma_mock_script
        @mock_script = MockScript.find(params[:id])
        @mock_script.date_user_asesor =  Time.now
        @mock_script.firm_user_asesor = 1
        
        if Current.user.id == @mock_script.user_asesor
            if @mock_script.save then
                redirect_to mock_script_path(@mock_script.id), notice: "Firmado correctamente!"
            else
                redirect_to mock_scripts_path, alert: "Se produjo un error en la firma." 
            end
        else
            redirect_to  mock_scripts_path, alert: "Su usuario no corresponde con el nombre de la firma." 
        end    

    end    

    private

    def mock_script_params
        params.require(:mock_script).permit(:space_for, :date_script, :time_script, 
        :type_emergency, :user_representante, :name_coordinator, :name_brigade, 
        :name_evacuation, :external_soport, :officer_committee, :coordinator_drill, 
        :alert_activation, :evacuation_count, :evacuation_first, :evacuation_second, 
        :withdraw_kit, :withdraw_stretcher, :withdraw_extinguisher, :verification, 
        :return_indication, :routes_evacuation, :emergency_exit, :emergency_resources, 
        :user_asesor, :date_user_asesor, :firm_user_asesor, :entity_id, :version, :code)
    end 

end  
   




