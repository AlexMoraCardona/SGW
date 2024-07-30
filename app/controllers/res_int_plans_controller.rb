class ResIntPlansController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @res_int_plans = ResIntPlan.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new
      @res_int_plan = ResIntPlan.new  
    end    

    def create
        @res_int_plan = ResIntPlan.new(res_int_plan_params)

        if @res_int_plan.save then
            redirect_to edit_emergency_plan_path(@res_int_plan.emergency_plan_id), notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @res_int_plan = ResIntPlan.find(params[:id])
    end
    
    def update
        @res_int_plan = ResIntPlan.find(params[:id])
        if @res_int_plan.update(res_int_plan_params)
            redirect_to edit_emergency_plan_path(@res_int_plan.emergency_plan_id), notice: 'Recurso interno actualizado correctamente'
        else
            render :edit, res_int_plans: :unprocessable_entity
        end         
    end    

    def destroy
        @res_int_plan = ResIntPlan.find(params[:id])
        @res_int_plan.destroy
        redirect_to edit_emergency_plan_path(@res_int_plan.emergency_plan_id), notice: 'Recurso interno borrado correctamente', res_int_plan: :see_other
    end    

    private

    def res_int_plan_params
        params.require(:res_int_plan).permit(:cant, :clase, :description, :ubication, :emergency_plan_id)
    end 

end  




