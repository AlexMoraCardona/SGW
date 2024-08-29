class EquipementUsedPlansController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @equipement_used_plans = EquipementUsedPlan.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in') 
             session.delete(:user_id)     
         end           
         
    end    

    def new
      @equipement_used_plan = EquipementUsedPlan.new  
    end    

    def create
        @equipement_used_plan = EquipementUsedPlan.new(equipement_used_plan_params)

        if @equipement_used_plan.save then
            redirect_to edit_emergency_plan_path(@equipement_used_plan.emergency_plan_id), notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @equipement_used_plan = EquipementUsedPlan.find(params[:id])
    end
    
    def update
        @equipement_used_plan = EquipementUsedPlan.find(params[:id])
        if @equipement_used_plan.update(equipement_used_plan_params)
            redirect_to edit_emergency_plan_path(@equipement_used_plan.emergency_plan_id), notice: 'Equipo actualizado correctamente'
        else
            render :edit, equipement_used_plans: :unprocessable_entity
        end         
    end    

    def destroy
        @equipement_used_plan = EquipementUsedPlan.find(params[:id])
        @equipement_used_plan.destroy
        redirect_to edit_emergency_plan_path(@equipement_used_plan.emergency_plan_id), notice: 'Equipo borrado correctamente', equipement_used_plan: :see_other
    end    

    private

    def equipement_used_plan_params
        params.require(:equipement_used_plan).permit(:type_equipement, :name, :emergency_plan_id )
    end 

end  


