class InvestigationsController < ApplicationController
    def index 
        if Current.user && Current.user.level > 0 && Current.user.level < 4 
            @entity = Entity.find(Current.user.entity)
            @investigations = Investigation.where("entity_id = ?",Current.user.entity)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end  
    
    def show
        @investigation = Investigation.find(params[:id])
        @entity = Entity.find(@investigation.entity_id) if @investigation.present?
        @inves_recomendations = InvesRecomendation.where("investigation_id = ?",@investigation.id) if @investigation.present?   
        @inves_users = InvesUser.where("investigation_id = ?",@investigation.id) if @investigation.present?   
        @template = Template.where("reference = ? and version = ?",@investigation.code,@investigation.version).last  
        @template_versions = Template.where(reference: @template.reference, standar_detail_item_id: @template.standar_detail_item_id).order(:date, :version) if @template.present?

        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Investigacion.xlsx"'
            }
        end    
    end  

    def recomendaciones
        @investigation = Investigation.find(params[:id])
        @entity = Entity.find(@investigation.entity_id) if @investigation.present?
        @recomendaciones = InvesRecomendation.where("investigation_id = ?",@investigation.id) if @investigation.present?
        @recomendacion = InvesRecomendation.new
    end
    
    def equipo_investigador
        @investigation = Investigation.find(params[:id])
        @entity = Entity.find(@investigation.entity_id) if @investigation.present?
        @investigadores =   InvesUser.where("investigation_id = ?",@investigation.id) if @investigation.present?
        @investigador = InvesUser.new
    end

    
    def new
      @investigation =  Investigation.new
      @entity = Entity.find(Current.user.entity)
      @template = Template.where("reference = ? and document_vigente = ?",'IAT-SST',1).last  
    end    

    def create
        @investigation = Investigation.new(investigation_params)
        if @investigation.save then
            redirect_to investigations_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
          @investigation = Investigation.find(params[:id])
          @entity = Entity.find(@investigation.entity_id)
          @template = Template.where("reference = ? and version = ?",@investigation.code,@investigation.version).last  

    end
    
    def update
        @investigation = Investigation.find(params[:id])
        if @investigation.update(investigation_params)
            redirect_to investigations_path, notice: 'Investigación actualizada correctamente'
        else
            render :edit, investigations: :unprocessable_entity
        end         
    end    

    def destroy
        @investigation = Investigation.find(params[:id])
        @investigation.destroy
        redirect_to investigations_path, notice: 'Investigación borrada correctamente', investigation: :see_other
    end  

    
    def ver_investigation
        @investigation = Investigation.find(params[:id])
        @entity = Entity.find(@investigation.entity_id) if @investigation.present?
        @inves_recomendations = InvesRecomendation.where("investigation_id = ?",@investigation.id) if @investigation.present?   
        @inves_users = InvesUser.where("investigation_id = ?",@investigation.id) if @investigation.present?   
        @template = Template.where("reference = ? and version = ?",@investigation.code,@investigation.version).last  
        @template_versions = Template.where(reference: @template.reference, standar_detail_item_id: @template.standar_detail_item_id).order(:date, :version) if @template.present?


        nombre_archivo = @template.reference.to_s + '.pdf'
        respond_to do |format| 
            format.html
            format.pdf {header_html = render_to_string( partial: 'templates/header')
                pdf = WickedPdf.new.pdf_from_string(
                    render_to_string('ver_investigation'),
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

    

    private

    def investigation_params
        params.require(:investigation).permit(:date_investigation, :type_event, 
        :accident_usual, :obs_accident_usual, :type_labor_connection, :age, 
        :job_experience, :date_income, :area, :phone, :date_accident, :time_accident, 
        :place, :inform_prompt, :obs_inform_prompt, :task_moment_accident, 
        :descript, :event_description, :version_work, :version_witness, 
        :similar_events, :obs_similar_events, :complementary_data, :photographic_record, 
        :immediate_cause1, :immediate_cause2, :immediate_cause3, :cause_basic1, 
        :cause_basic2, :cause_basic3, :plan_action, :unsafe_acts, :unsafe_conditions, 
        :personal_factors, :adm_factors, :affected_part, :type_injury, 
        :accident_mechanism, :disability_days, :usr_profesional, :name_profesional, 
        :firm_profesional, :date_firm_profesional, :license, :space_for_injury, 
        :space_for_agente, :de, :entity_id, :user_id, :datos_complementarios, :plan_accion, 
        :actos_inseguros, :condiciones_inseguras, :factores_personales, :factores_administrativos, 
        :state_investigation, :date_state_investigation, :version, :code, registros_fotograficos: [] )
    end 

end  
   




