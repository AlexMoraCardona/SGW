class BrigadistaPlansController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @brigadista_plans = BrigadistaPlan.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')   
             session.delete(:user_id)   
         end           
         
    end    

    def new
      @brigadista_plan = BrigadistaPlan.new  
    end    

    def create
        @brigadista_plan = BrigadistaPlan.new(brigadista_plan_params)

        if @brigadista_plan.save then
            redirect_to edit_emergency_plan_path(@brigadista_plan.emergency_plan_id), notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @brigadista_plan = BrigadistaPlan.find(params[:id])
    end
    
    def update
        @brigadista_plan = BrigadistaPlan.find(params[:id])
        if @brigadista_plan.update(brigadista_plan_params)
            redirect_to edit_emergency_plan_path(@brigadista_plan.emergency_plan_id), notice: 'Brigadista plan de emergencia actualizado correctamente'
        else
            render :edit, brigadista_plans: :unprocessable_entity
        end         
    end    

    def destroy
        @brigadista_plan = BrigadistaPlan.find(params[:id])
        @brigadista_plan.destroy
        redirect_to edit_emergency_plan_path(@brigadista_plan.emergency_plan_id), notice: 'Brigadista plan de emergencia borrado correctamente', brigadista_plan: :see_other
    end    

    private

    def brigadista_plan_params
        params.require(:brigadista_plan).permit(:name_brigadista, :perfil_brigadista, :emergency_plan_id)
    end 

end  


