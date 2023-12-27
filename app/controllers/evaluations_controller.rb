class EvaluationsController < ApplicationController
    def index
        if  Current.user && Current.user.level == 1
            if params[:entity_id].present?
                    @evaluations = Evaluation.where(entity_id: params[:entity_id]).order(date_evaluation: :desc)
            else    
                @evaluations = Evaluation.all.order(date_evaluation: :desc)
            end  
         else
             redirect_to new_session_path, alert: t('common.not_logged_in')      
         end           
         
    end    

    def crear_evaluacion 
        @existe = EvaluationRuleDetail.where(evaluation_id: params[:format].to_i).first
        if @existe then
            redirect_to evaluations_path, alert: "Los Items ya fueron creados"        
        else
            @evaluation = Evaluation.find_by(id: params[:format].to_i)
            @standars = Standar.where(rule_id: @evaluation.rule_id.to_i)
            @standar_details = StandarDetail.where(standar_id: @standars.ids)
            @standar_detail_items = StandarDetailItem.where(standar_detail_id: @standar_details.ids)
            
            Evaluation.new_evaluation(@standar_detail_items, @evaluation)
            redirect_to evaluations_path, notice: "Se crearon #{@cont} Items correctamente"
        end    
    end    

    def crear_historia 
        @evaluation = Evaluation.find_by(id: params[:format].to_i)
        @evaluation_items = EvaluationRuleDetail.where(evaluation_id: params[:format].to_i)
        Evaluation.new_history(@evaluation, @evaluation_items)
    
        redirect_to evaluations_path, notice: "Finalizo la copia de la evaluación, por favor validar"
    end    

    def ver_history 
        @history_evaluations = HistoryEvaluation.where(evaluation_id: params[:id]) if params[:id].present?
    end

    def planificar
        redirect_to evaluation_path
    end    

    def new
      @evaluation = Evaluation.new  
    end    

    def create
        @evaluation = Evaluation.new(evaluation_params)

        if @evaluation.save then
            redirect_to evaluations_path, notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def show
        @evaluation = Evaluation.find(params[:id]) 
        @evaluation_items = EvaluationRuleDetail.where("evaluation_id = ? and apply = ?", @evaluation.id, 1).order(:order_nro).decorate
        #Evaluation.calculo_score_evaluacion(@evaluation.id)  
        respond_to do |format|
            format.html
            format.xlsx{ 
                response.headers['Content-Disposition'] = 'attachment; filename="Evaluacion.xlsx"'
            }
        end    

    end

    def edit 
        @evaluation = Evaluation.find(params[:id])
    end


    
    def update 
        @evaluation = Evaluation.find(params[:id])
        if @evaluation.update(evaluation_params)
            redirect_to evaluations_path, notice: 'Evaluación actualizada correctamente'
        else
            render :edit, evaluations: :unprocessable_entity
        end
        #calculo_score_evaluacion(@evaluation.id)         

    end    

    def destroy
        @evaluation = Evaluation.find(params[:id]) 
        @evaluation.destroy
        redirect_to evaluations_path, notice: 'Evaluación borrada correctamente', status: :see_other
    end     

    private

    def evaluation_params
        params.require(:evaluation).permit(:entity_id, :date_evaluation, :number_employees, :risk_level_id, :rule_id, :score,
        :percentage, :result, :observation)
    end 
end  