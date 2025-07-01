class InvestigationsController < ApplicationController
    def index 
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            if params[:entity_id].present?
                @entity = Entity.find(params[:entity_id])
                @investigations = Investigation.where("entity_id = ?", params[:entity_id]).order(id: :desc)
            else 
                @entities = Entity.all
            end    
        elsif Current.user && Current.user.level == 3 
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
        @template = Template.where("format_number = ? and document_vigente = ?",103,1).last  
        @inves_recomendations = InvesRecomendation.where("investigation_id = ?",@investigation.id) if @investigation.present?   
        @inves_users = InvesUser.where("investigation_id = ?",@investigation.id) if @investigation.present?   

        @template = Template.where("format_number = ? and document_vigente = ?",103,1).last  
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Investigacion.xlsx"'
            }
        end    
    end  
    
    def ver_investigacion
        @investigation = Investigation.find(params[:id])
        @entity = Entity.find(@investigation.entity_id) if @investigation.present?
        @template = Template.where("format_number = ? and document_vigente = ?",103,1).last  
        @inves_recomendations = InvesRecomendation.where("investigation_id = ?",@investigation.id) if @investigation.present?   
        @inves_users = InvesUser.where("investigation_id = ?",@investigation.id) if @investigation.present?   

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_investigacion',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
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
      @template = Template.where("format_number = ? and document_vigente = ?",103,1).last  
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
          @template = Template.where("format_number = ? and document_vigente = ?",103,1).last  
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
          @entity = Entity.find(@investigation.entity_id)
          @template = Template.where("format_number = ? and document_vigente = ?",103,1).last  

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_investigation',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
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
        :space_for_agente, :de, :entity_id, :user_id, :datos_complementarios, :plan_accion, :actos_inseguros, :condiciones_inseguras, :factores_personales, :factores_administrativos, registros_fotograficos: [] )
    end 

end  
   




