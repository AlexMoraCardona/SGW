class HistoryEvaluationsController < ApplicationController

    def index 
        if  Current.user && Current.user.level == 1
            @history_evaluations = HistoryEvaluation.all
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def new 
      @history_evaluation = HistoryEvaluation.new  

    end    

    def create
        @history_evaluation = HistoryEvaluation.new(history_evaluation_params)
        if @history_evaluation.save then
            redirect_back fallback_location: root_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end     
    end 

    def show
        @history_evaluation = HistoryEvaluation.find(params[:id])
        @history_items = HistoryItem.where(history_evaluation_id: @history_evaluation.id).order(:cycle, :order_nro).decorate if @history_evaluation.present?
        respond_to do |format| 
            format.html
            format.pdf {render  template: 'history_evaluations/descargar',
            page_size: 'letter',
            margin: {top: 10, bottom: 10, left: 10, right: 10 },
            footer: {
                right: 'Página: [page] de [topage]'
               }                
        }
        end  
    end    

 
    def edit
        @history_evaluation = HistoryEvaluation.find(params[:id])
    end
    
    def update
        
        @history_evaluation = HistoryEvaluation.find(params[:id])
        if @history_evaluation.update(history_evaluation_params)
            redirect_back fallback_location: root_path, notice: 'Historia de la evaluación actualizada correctamente'
        else
            render :edit, history_evaluations: :unprocessable_entity
        end         
    end    

    def destroy
        @history_evaluation = HistoryEvaluation.find(params[:id])
        @history_evaluation.destroy
        redirect_back fallback_location: root_path, notice: 'Historia de la evaluación borrada correctamente', history_evaluation: :see_other
    end    

    private     
    def history_evaluation_params
        params.require(:history_evaluation).permit(:date_create_evaluation, :date_history_evaluation, 
        :number_employees, :score, :percentage, :result, :observation, :id_employee_contractor, :firm_employee_contractor,
        :date_firm_employee, :id_responsible_execution, :firm_responsible_execution, :date_firm_responsible, 
        :completed_items, :unfulfilled_items, :not_apply_items, :rule_id, :risk_level_id, :evaluation_id, :entity_id)
    end 
end    