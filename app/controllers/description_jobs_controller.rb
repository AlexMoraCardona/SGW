class DescriptionJobsController < ApplicationController
    def index
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @description_jobs = DescriptionJob.where("entity_id = ?", params[:entity_id])
        else    
            if  Current.user && Current.user.level > 0 && Current.user.level < 3
                @entities = Entity.all
                @description_jobs = DescriptionJob.all
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')    
                session.delete(:user_id)  
            end           
        end 
    end    

    def new
      @description_job = DescriptionJob.new  
    end    

    def create
        @description_job = DescriptionJob.new(description_job_params)

        if @description_job.save then
            redirect_to description_jobs_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @description_job = DescriptionJob.find(params[:id])
        @entity = Entity.find(@description_job.entity_id) if @description_job.present?
    end
    
    def show
        @description_job = DescriptionJob.find(params[:id])
        @entity = Entity.find(@description_job.entity_id) if @description_job.present?
        @template = Template.where("format_number = ? and document_vigente = ?",36,1).last  
        @ela = User.find(@description_job.user_elaboro) if  @description_job.user_elaboro.present? && @description_job.user_elaboro > 0
        @rev = User.find(@description_job.user_reviso) if  @description_job.user_reviso.present? && @description_job.user_reviso > 0
        @apr = User.find(@description_job.user_aprobo) if  @description_job.user_aprobo.present? && @description_job.user_aprobo > 0
    end

    def update
        @description_job = DescriptionJob.find(params[:id])
        if @description_job.update(update_description_job_params)
            redirect_to description_jobs_path, notice: 'Cargo actualizado correctamente'
        else
            render :edit, description_jobs: :unprocessable_entity
        end         
    end    

    def destroy
        @description_job = DescriptionJob.find(params[:id])
        @description_job.destroy
        redirect_to description_jobs_path, notice: 'Cargo borrado correctamente', description_job: :see_other
    end    

    def firmar_ela 
        @description_job = DescriptionJob.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @description_job.user_elaboro.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_ela_description_jobs_path   
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma."
            end    
        end
    end    

    def firmar_rev 
        @description_job = DescriptionJob.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @description_job.user_reviso.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_rev_description_jobs_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma."
            end    
        end
    end    

    def firmar_apr 
        @description_job = DescriptionJob.find_by(id: params[:id].to_i)
        if params[:format].to_i == 3
            if  @description_job.user_aprobo.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_apr_description_jobs_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma."
            end    
        end
    end    

    def pdf
        @description_job = DescriptionJob.find(params[:id])
        @entity = Entity.find(@description_job.entity_id) if @description_job.present?
        @template = Template.where("format_number = ? and document_vigente = ?",36,1).last  
        @ela = User.find(@description_job.user_elaboro) if  @description_job.user_elaboro.present? && @description_job.user_elaboro > 0
        @rev = User.find(@description_job.user_reviso) if  @description_job.user_reviso.present? && @description_job.user_reviso > 0
        @apr = User.find(@description_job.user_aprobo) if  @description_job.user_aprobo.present? && @description_job.user_aprobo > 0

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'pdf',
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

    def description_job_params
        params.require(:description_job).permit(:entity_id, :name_job, :immediate_boss,
         :objetive_job, :academic_training, :experience, :salary_range, :type_contract,
          :working_hours, :required_knowledge, :competencies, :job_functions,
           :roles_responsibilities, :observations, :user_elaboro, :user_reviso,
            :user_aprobo, :date_firm_elaboro, :date_firm_reviso, :date_firm_aprobo,
             :firm_elaboro, :firm_reviso, :firm_aprobo, :state_job )
    end 

    def update_description_job_params
        params.require(:description_job).permit(:entity_id, :name_job, :immediate_boss,
         :objetive_job, :academic_training, :experience, :salary_range, :type_contract,
          :working_hours, :required_knowledge, :competencies, :job_functions,
           :roles_responsibilities, :observations, :date_firm_elaboro, :date_firm_reviso, :date_firm_aprobo,
             :firm_elaboro, :firm_reviso, :firm_aprobo, :state_job )
    end 

end  
