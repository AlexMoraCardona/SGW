class UnsafeConditionsController < ApplicationController
    def index
        if params[:entity_id].present?
            @entity = Entity.find(params[:entity_id])
            @unsafe_conditions = UnsafeCondition.where(entity_id: @entity.id).order(:date_report) if @entity.id.present?
        else    
            if  Current.user && Current.user.level == 1
                @entities = Entity.all
                @unsafe_conditions = UnsafeCondition.all
            else
                redirect_to new_session_path, alert: t('common.not_logged_in')      
            end           
        end 
    end    

    def new
      @unsafe_condition = UnsafeCondition.new  
    end    

    def create
        @unsafe_condition = UnsafeCondition.new(unsafe_condition_params)
        if @unsafe_condition.save then
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
            redirect_to unsafe_conditions_path, notice: 'Reporte actualizado correctamente'
        else
            render :edit, unsafe_conditions: :unprocessable_entity
        end         
    end    

    def destroy
        @unsafe_condition = UnsafeCondition.find(params[:id])
        @unsafe_condition.destroy
        redirect_to unsafe_conditions_path, notice: 'Reporte borrado correctamente', unsafe_condition: :see_other
    end    

    def show
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
        :firm_user_reports, :firm_user_receiving, :firm_user_coordinator, :entity_id)
    end 

end  



