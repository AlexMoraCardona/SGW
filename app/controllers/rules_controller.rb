class RulesController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @rules = Rule.all.decorate
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')     
             session.delete(:user_id) 
         end           
         
    end    

    def new
      @rule = Rule.new  
    end    

    def create
        @rule = Rule.new(rule_params)

        if @rule.save then
            redirect_to rules_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @rule = Rule.find(params[:id])
    end
    
    def update
        @rule = Rule.find(params[:id])
        if @rule.update(rule_params)
            redirect_to rules_path, notice: 'Ciclo actualizado correctamente'
        else
            render :edit, rules: :unprocessable_entity
        end         
    end    

    def destroy
        @rule = Rule.find(params[:id])
        @rule.destroy
        redirect_to rules_path, notice: 'Norma borrada correctamente', rule: :see_other
    end    

    private

    def rule_params
        params.require(:rule).permit(:name, :description, :creation_date, :date_update)
    end 

end  