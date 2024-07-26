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
            actualizar_fecha(@evaluation.id)
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
    
    def ver_evaluation_pdf
        @evaluation = Evaluation.find(params[:id])
        @evaluation_rule_details = EvaluationRuleDetail.where("evaluation_id = ?", @evaluation.id).order(:id)  if @evaluation.present?
        @entity = Entity.find(@evaluation.entity_id) if @evaluation.present?
        @user_responsible = User.find(@evaluation.user_responsible) if @evaluation.user_responsible > 0
        @user_representante = User.find(@evaluation.user_representante) if @evaluation.user_representante > 0

        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'ver_evaluation_pdf',
                margin: {top: 10, bottom: 10, left: 10, right: 10 },
                disable_javascript: true,
                page_size: 'letter',
                footer: {
                    right: 'Página: [page] de [topage]'
                   }                
                       } 
        end

    end     

    def actualizar_fecha(id)
        @evaluation = Evaluation.find(id)
        @evaluation.date_firm_representante = nil if @evaluation.firm_representante.to_i == 0
        @evaluation.date_firm_responsible = nil if @evaluation.firm_responsible.to_i == 0
        @evaluation.save
    end   

    def firmar_representante_evaluation 
        @evaluation = Evaluation.find_by(id: params[:id].to_i)
        if params[:format].to_i == 1
            if  @evaluation.user_representante.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_representante_evaluation_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Representante Legal."
            end    
        end
    end    

    def firmar_responsable_evaluation
        @evaluation = Evaluation.find_by(id: params[:id].to_i)
        if params[:format].to_i == 2
            if  @evaluation.user_responsible.to_i == Current.user.id.to_i || (Current.user.level < 3 && Current.user.level > 0)
                redirect_to firmar_responsable_evaluation_path
            else
                redirect_back fallback_location: root_path, alert: "Su usuario no esta autorizado para actualizar la firma del Responsable de la ejecución del SG-SST."
            end    
        end
    end    



    private

    def evaluation_params
        params.require(:evaluation).permit(:entity_id, :date_evaluation, :number_employees, :risk_level_id, :rule_id, :score,
        :percentage, :result, :observation, :user_responsible, :date_firm_responsible, :firm_responsible, :user_representante, :date_firm_representante, :firm_representante)
    end 
end  

