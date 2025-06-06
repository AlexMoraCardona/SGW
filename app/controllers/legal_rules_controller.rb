class LegalRulesController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            @legal_rules = LegalRule.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')     
             session.delete(:user_id) 
         end           
         
    end    

    def new
      @legal_rule = LegalRule.new  
    end    

    def create
        @legal_rule = LegalRule.new(legal_rule_params)

        if @legal_rule.save then
            redirect_to legal_rules_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @legal_rule = LegalRule.find(params[:id])
    end
    
    def update
        @legal_rule = LegalRule.find(params[:id])
        if @legal_rule.update(legal_rule_params)
            redirect_to legal_rules_path, notice: 'Norma Legal actualizada correctamente'
        else
            render :edit, legal_rules: :unprocessable_entity
        end         
    end    

    def destroy
        @legal_rule = LegalRule.find(params[:id])
        @legal_rule.destroy
        redirect_to legal_rules_path, notice: 'Norma Legal borrada correctamente', legal_rule: :see_other
    end    

    private

    def legal_rule_params
        params.require(:legal_rule).permit(:risk_factor, :requirement, :rule_name, 
        :fecha_norma, :issuing_entity, :applicable_article, :description_compliance, 
        :state_norma, :clasification_norma, :fec_norma, :year)
    end 

end  

