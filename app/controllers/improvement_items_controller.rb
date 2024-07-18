class ImprovementItemsController < ApplicationController
    def index 
        if  Current.user && Current.user.level == 1
            @improvement_items = ImprovementItem.all
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')      
        end           
    end  
    
    def new
      @improvement_item = ImprovementItem.new  
    end    

    def create
        @improvement_item = ImprovementItem.new(improvement_item_params)

        if @improvement_item.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @improvement_item = ImprovementItem.find(params[:id])
    end
    
    def update
        @improvement_item = ImprovementItem.find(params[:id])
        @improvement_plan = ImprovementPlan.find(@improvement_item.improvement_plan_id) if @improvement_item.present?

        if @improvement_item.update(improvement_item_params)
            redirect_to improvement_plans_path(entity_id: @improvement_plan.entity_id), notice: t('.created')
        else
            render :edit, improvement_plans: :unprocessable_entity
        end         
    end    

    def destroy
        @improvement_item = ImprovementItem.find(params[:id])
        @improvement_item.destroy
        redirect_to improvement_items_path, notice: 'Actividad borrada correctamente', improvement_item: :see_other
    end    

    private

    def improvement_item_params
        params.require(:improvement_item).permit(:activity_plan, :action_improvement, :date_initial, :date_fin, :aim_improvement, :resources_improvement, :responsible_action, :percentage_compliance, :improvement_plan_id, :observation, file_improvements: [])
    end  

end  



