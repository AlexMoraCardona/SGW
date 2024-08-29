class WorkingConditionItemsController < ApplicationController
    def index 
        if  Current.user && Current.user.level == 1
            @working_condition_items = WorkingConditionItem.all
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')      
            session.delete(:user_id)
        end           
    end  
    
    def new
      @working_condition_item = WorkingConditionItem.new  
    end    

    def create
        @working_condition_item = WorkingConditionItem.new(working_condition_item_params)

        if @working_condition_item.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @working_condition_item = WorkingConditionItem.find(params[:id])
    end
    
    def update
        @working_condition_item = WorkingConditionItem.find(params[:id])
        if @working_condition_item.update(working_condition_item_params)
            redirect_to  detalles_working_path(@working_condition_item.working_condition_id), notice: "Riesgo actualizado correctamente."
        else
            render :edit, working_conditions: :unprocessable_entity
        end         
    end    

    def destroy
        @working_condition_item = WorkingConditionItem.find(params[:id])
        @working_condition_item.destroy
        redirect_to working_condition_items_path, notice: 'Detalle borrado correctamente', working_condition_item: :see_other
    end  
    
   

    private

    def working_condition_item_params
        params.require(:working_condition_item).permit(:exposed, :observation, :working_condition_id, :clasification_danger_id, :clasification_danger_detail_id, :user_intervention, :date_intervention, :observation_intervention, :intervention )
    end  

end  





