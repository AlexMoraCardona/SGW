class SituationConditionsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @situation_conditions = SituationCondition.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
    end    

    def new
      @situation_condition = SituationCondition.new  
    end    

    def create
        @situation_condition = SituationCondition.new(situation_condition_params)

        if @situation_condition.save then
            redirect_to situation_conditions_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @situation_condition = SituationCondition.find(params[:id])
    end
    
    def update
        @situation_condition = SituationCondition.find(params[:id])
        if @situation_condition.update(situation_condition_params)
            redirect_to situation_conditions_path, notice: 'Situación o Condición actualizada correctamente'
        else
            render :edit, situation_conditions: :unprocessable_entity
        end         
    end    

    def destroy
        @situation_condition = SituationCondition.find(params[:id])
        @situation_condition.destroy
        redirect_to situation_conditions_path, notice: 'Situación o Condición borrada correctamente', situation_condition: :see_other
    end    

    private

    def situation_condition_params
        params.require(:situation_condition).permit(:name, :type_condition_inspection_id)
    end 
end  