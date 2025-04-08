class SafetyInspectionItemsController < ApplicationController
    def index 
        if  Current.user && Current.user.level == 1
            @safety_inspection_items = SafetyInspectionItem.all
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')   
            session.delete(:user_id)   
        end           
    end  
    
    def new
      @safety_inspection_item = SafetyInspectionItem.new  
    end    

    def create
        @safety_inspection_item = SafetyInspectionItem.new(safety_inspection_item_params)

        if @safety_inspection_item.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @safety_inspection_item = SafetyInspectionItem.find(params[:id])
    end
    
    def update
        @safety_inspection_item = SafetyInspectionItem.find(params[:id])
        @safety_inspection = SafetyInspection.find(@safety_inspection_item.safety_inspection_id) if @safety_inspection_item.present?

        if @safety_inspection_item.update(safety_inspection_item_params)
            #redirect_to safety_inspections_path(entity_id: @safety_inspection.entity_id), notice: t('.created')
        else
            render :edit, audit_reports: :unprocessable_entity
        end         
    end    

    def destroy
        @safety_inspection_item = SafetyInspectionItem.find(params[:id])
        @safety_inspection_item.destroy
        redirect_to safety_inspection_items_path, notice: 'Condición o situación borrada correctamente', safety_inspection_item: :see_other
    end    

    private

    def safety_inspection_item_params
        params.require(:safety_inspection_item).permit(:state_compliance, :observation, :safety_inspection_id, :situation_condition_id, 
                        :recommendations, :proposed_intervention, inspection_evidences: [])
    end  
end  

