class UnsafeConditionsController < ApplicationController
    def index
        if  Current.user && Current.user.level > 0 && Current.user.level < 3
            if params[:entity_id].present?
                @entity = Entity.find(params[:entity_id])
                @unsafe_conditions = UnsafeCondition.where("entity_id = ?", params[:entity_id]).order(id: :desc)
            else 
                @entities = Entity.all
            end    
        elsif Current.user && Current.user.level == 3 
            @entity = Entity.find(Current.user.entity)
            @unsafe_conditions = UnsafeCondition.where("entity_id = ?",Current.user.entity)
        elsif Current.user && Current.user.level == 5 
            @entity = Entity.find(Current.user.entity)
            @unsafe_conditions = UnsafeCondition.where("entity_id = ? and user_reports = ?",Current.user.entity, Current.user.id)
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')    
            session.delete(:user_id)  
        end     
    end    

    def new
      @unsafe_condition = UnsafeCondition.new 
      @entity = Entity.find(params[:entity_id].to_i) if params[:entity_id].present? 
      @asesor_recibe = User.find(@entity.responsible_sst) if @entity.responsible_sst > 0 
    end    

    def create
        @unsafe_condition  = UnsafeCondition.new(unsafe_condition_params)
        if @unsafe_condition.save then
            UnsafeCondition.evaluarcondicion(@unsafe_condition.id)
            firmaautomatica(@unsafe_condition.id)
            redirect_to unsafe_conditions_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @unsafe_condition = UnsafeCondition.find(params[:id])
        @entity = Entity.find(@unsafe_condition.entity_id)
    end
    
    def update
        @unsafe_condition = UnsafeCondition.find(params[:id])
        if @unsafe_condition.update(unsafe_condition_params)
            actualizar_fecha(@unsafe_condition.id)
            redirect_to unsafe_conditions_path, notice: 'Reporte actualizado correctamente'
        else
            render :edit, unsafe_conditions: :unprocessable_entity
        end         
    end  
    
    def actualizar_fecha(id)
        @unsafe_condition = UnsafeCondition.find(id)
        @unsafe_condition.date_firm_user_reports = nil if @unsafe_condition.firm_user_reports.to_i == 0
        @unsafe_condition.date_firm_user_receiving = nil if @unsafe_condition.firm_user_receiving.to_i == 0
        @unsafe_condition.save
    end    
    
    def firmaautomatica(id)
        @unsafe_condition = UnsafeCondition.find(id)
        @unsafe_condition.date_firm_user_reports = Time.now
        @unsafe_condition.firm_user_reports = 1
        @unsafe_condition.save
    end    

    def destroy
        @unsafe_condition = UnsafeCondition.find(params[:id])
        @unsafe_condition.destroy
        redirect_to unsafe_conditions_path, notice: 'Reporte borrado correctamente', unsafe_condition: :see_other
    end    

    def show
        @template = Template.where("format_number = ? and document_vigente = ?",64,1).last  
        @unsafe_condition = UnsafeCondition.find(params[:id])
        @reporta = User.find(@unsafe_condition.user_reports) if  @unsafe_condition.user_reports.present? && @unsafe_condition.user_reports > 0
        @recibe = User.find(@unsafe_condition.user_receiving) if  @unsafe_condition.user_receiving.present? && @unsafe_condition.user_receiving > 0
        @coordinador = User.find(@unsafe_condition.user_coordinator) if  @unsafe_condition.user_coordinator.present? && @unsafe_condition.user_coordinator > 0
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    
    end    

    def firmar_reporta
        @unsafe_condition = UnsafeCondition.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @unsafe_condition.user_reports.to_i == Current.user.id.to_i
                redirect_to firmar_reporta_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma."
            end    
        end
    end    

    def firmar_recibe
        @unsafe_condition = UnsafeCondition.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @unsafe_condition.user_receiving.to_i == Current.user.id.to_i
                redirect_to firmar_recibe_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma."
            end    
        end
    end  
    
    def add_evidences
        @unsafe_condition = UnsafeCondition.find_by(id: params[:id].to_i)

    end     
    
    def unsafe_condition_pdf
        @template = Template.where("format_number = ? and document_vigente = ?",64,1).last  
        @unsafe_condition = UnsafeCondition.find(params[:id])
        @reporta = User.find(@unsafe_condition.user_reports) if  @unsafe_condition.user_reports.present? && @unsafe_condition.user_reports > 0
        @recibe = User.find(@unsafe_condition.user_receiving) if  @unsafe_condition.user_receiving.present? && @unsafe_condition.user_receiving > 0
        @coordinador = User.find(@unsafe_condition.user_coordinator) if  @unsafe_condition.user_coordinator.present? && @unsafe_condition.user_coordinator > 0

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'unsafe_condition_pdf',
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

    def unsafe_condition_params 
        params.require(:unsafe_condition).permit(:date_report, :place_report, :user_reports, :description_condition, 
        :equipment_condition, :floors_condition, :not_demarcate_areas, :gases_dusts, :unsafe_work_design, 
        :inadequate_signage, :defective_tools, :lack_alarm, :lack_cleanliness, :lack_space_work, :incorrect_storage, 
        :excessive_noise_levels, :inadequate_lighting_ventilation, :other_unsafe_conditions, :description_act_unsafe, 
        :not_using_equipment, :operating_without_authorization, :running_facilities, :using_defective_tool, 
        :psychoactive_substances, :ignore_dangerous, :use_wrong_tool, :wrong_position, :heights_without_authorization, 
        :workplace_distractions, :gen_on_desk, :other_features, :alternative_soluctions, :user_receiving, 
        :user_coordinator, :date_firm_user_reports, :date_firm_user_receiving, :date_firm_user_coordinator, 
        :firm_user_reports, :firm_user_receiving, :firm_user_coordinator, :entity_id, :exact_ubication, evidencias: [])
    end 

end  



