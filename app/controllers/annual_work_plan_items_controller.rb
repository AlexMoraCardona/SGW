class AnnualWorkPlanItemsController < ApplicationController
    def index 
        if  Current.user && Current.user.level == 1
            @annual_work_plan_items = AnnualWorkPlanItem.all
        else
            redirect_to new_session_path, alert: t('common.not_logged_in')     
            session.delete(:user_id) 
        end           
    end  
    
    def new
      @annual_work_plan_item = AnnualWorkPlanItem.new  
    end    

    def create
        @annual_work_plan_item = AnnualWorkPlanItem.new(annual_work_plan_item_params)

        if @annual_work_plan_item.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @annual_work_plan_item = AnnualWorkPlanItem.find(params[:id])
    end
    
    def update
        @annual_work_plan_item = AnnualWorkPlanItem.find(params[:id])
        if @annual_work_plan_item.update(annual_work_plan_item_params)
            redirect_to crear_item_plan_annual_work_plans_path(@annual_work_plan_item.annual_work_plan_id), notice: t('.created')
        else
            render :edit, annual_work_plans: :unprocessable_entity
        end         
    end    

    def destroy
        @annual_work_plan_item = AnnualWorkPlanItem.find(params[:id])
        @annual_work_plan_item.destroy
        redirect_to annual_work_plan_items_path, notice: 'Objetivo borrado correctamente', annual_work_plan_item: :see_other
    end    

    private

    def annual_work_plan_item_params
        params.require(:annual_work_plan_item).permit(:consecutive, :aim, :goal,
        :activity, :resource, :responsible, :date_realization, :month, 
        :observation, :evidences_plan, :earring, :annual_work_plan_id, observation_evidences: [] )
    end  

end  

