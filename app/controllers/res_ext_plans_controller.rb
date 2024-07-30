class ResExtPlansController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @res_ext_plans = ResExtPlan.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new
      @res_ext_plan = ResExtPlan.new  
    end    

    def create
        @res_ext_plan = ResExtPlan.new(res_ext_plan_params)

        if @res_ext_plan.save then 
            redirect_to edit_emergency_plan_path(@res_ext_plan.emergency_plan_id), notice: t('.created')
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @res_ext_plan = ResExtPlan.find(params[:id])
    end
    
    def update
        @res_ext_plan = ResExtPlan.find(params[:id])
        if @res_ext_plan.update(res_ext_plan_params)
            redirect_to edit_emergency_plan_path(@res_ext_plan.emergency_plan_id), notice: 'Recurso externo actualizado correctamente'
        else
            render :edit, res_ext_plans: :unprocessable_entity
        end         
    end    

    def destroy
        @res_ext_plan = ResExtPlan.find(params[:id])
        @res_ext_plan.destroy
        redirect_to edit_emergency_plan_path(@res_ext_plan.emergency_plan_id), notice: 'Recurso externo borrado correctamente', res_ext_plan: :see_other
    end    

    private

    def res_ext_plan_params
        params.require(:res_ext_plan).permit(:name, :place, :phone, :cant, :emergency_plan_id)
    end 

end  




