class EvaluationRuleDetailsController < ApplicationController

    def index 
         
        if  Current.user && Current.user.level == 1
            @evaluation_rule_details = EvaluationRuleDetail.all.order(:evaluation_id).decorate 
            if params[:evaluation_id].present?
                @evaluation_rule_details = @evaluation_rule_details.where("evaluation_id = ?", params[:evaluation_id])
            end    
        else
            if Current.user && Current.user.level > 1
                @evaluations = Evaluation.where(entity_id: Current.user.entity).order(:id)
                @evaluations.each do |evaluation|
                    @evaluation_rule_details = EvaluationRuleDetail.where(evaluation_id: evaluation.id).decorate 
                end    
            else  
                redirect_to new_session_path, alert: t('common.not_logged_in')       
            end
        end        
    end 
    
    def crear_evidencia
        @evidence = Evidence.new

        @evidence.entity_id = params[:entity_id]
        @evidence.evaluation_rule_detail_id = params[:evaluacion_rule_detail_id] 
        @evidence.template_id = params[:template_id]
        @evidence.date = Time.now
        if @evidence.save then
            crear_firmas
            crear_participantes 
            redirect_to edit_evaluation_rule_detail_path(params[:evaluacion_rule_detail_id]), notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end  
    
    def crear_firmas
        
    end    
    def crear_participantes

    end    

    def crear_firma
        @firm  = Firm.new  
        @firms = Firm.where("evidence_id = ?", params[:id]).decorate if params[:id].present?
    end  
    
    def crear_participant
        @participant = Participant.new  
        @participants = Participant.where("evidence_id = ?", params[:id]) if params[:id].present?
    end  
 
    def actualizar_evidencia
        @evidence = Evidence.find(params[:id])
    end    

    def ver_evidencia
        @evidence = Evidence.find(params[:id])
        @firms = Firm.where("evidence_id = ?", @evidence.id)
        @participants = Participant.where("evidence_id = ?", @evidence.id) if @evidence.present?
        @firms.each do |firm| 
            @representante_legal = User.find(firm.user_id) if firm.legal_representative == 1 
        end  
        @participants.each do |participant| 
            @responsable_ssst = User.find(participant.user_id) if participant.responsible_ssst == 1 
            @asesor_externo_ssst = User.find(participant.user_id) if participant.external_consultant == 1 
            @colaborador_ssst = User.find(participant.user_id) if participant.collaborator == 1 && participant.person_complaining == 0 
            @presidente_comite = User.find(participant.user_id) if participant.joint_committee_president == 1 
            @secretario_comite = User.find(participant.user_id) if participant.joint_committee_secretary == 1 
            @vigia = User.find(participant.user_id) if participant.vigia == 1 
            @colaborador_queja = User.find(participant.user_id) if participant.person_complaining == 1 
        end          
        @vista = 'evaluation_rule_details/plantillas/' + @evidence.template_id.to_s 
        @footer = 'Nit: ' + @evidence.entity.identification_number.to_s + ', Dirección: ' + @evidence.entity.entity_address.to_s
        respond_to do |format| 
            format.html
            format.pdf {render  pdf: 'evidencia', 
                disable_javascript: true,
                margin: {top: 45, bottom: 25, left: 25, right: 25 },
                page_size: 'Letter',
                header: {
                         html: { 
                         template: 'evaluation_rule_details/headerformato'
                         }},
                footer: {
                         right: 'Página: [page] de [topage]'
                        }
                
                       } 
        end
      
    end
  
    def search
    end
        
    def new
      @evaluation_rule_detail = EvaluationRuleDetail.new  
    end    

    def create
        @evaluation_rule_detail = EvaluationRuleDetail.new(evaluation_rule_detail_params)

        if @evaluation_rule_detail.save then
            redirect_to evaluation_rule_detail_path, notice: t('.created')  
        else
            render :edit, status: :unprocessable_entity
        end    
    end    
 
    def edit
        @evaluation_rule_detail = EvaluationRuleDetail.find(params[:id])
        @templates = Template.where("standar_detail_item_id = ?", @evaluation_rule_detail.standar_detail_item_id)
        @evidences = Evidence.where("evaluation_rule_detail_id = ?", @evaluation_rule_detail.id).order(date: :desc)
    end
    
    def update  
        @evaluation_rule_detail = EvaluationRuleDetail.find(params[:id])
        if params[:evaluation_rule_detail][:meets].present?
            @evaluation_rule_detail.meets =  params[:evaluation_rule_detail][:meets].to_i
        end
        @evaluation_rule_detail.score = @evaluation_rule_detail.maximun_value if @evaluation_rule_detail.meets.to_i > 0  
        @evaluation_rule_detail.score = 0 if @evaluation_rule_detail.meets.to_i == 0
 
        if @evaluation_rule_detail.update(evaluation_rule_detail_params)
            EvaluationRuleDetail.calculo_variables(@evaluation_rule_detail.evaluation_id) if @evaluation_rule_detail.present? 
            if  params[:evaluation_rule_detail][:meets].present?
                redirect_to evaluation_path(@evaluation_rule_detail.evaluation_id)     
            else 
                redirect_to edit_evaluation_rule_detail_path(@evaluation_rule_detail.id)
            end 
        else
            render :edit, evaluation_rule_details: :unprocessable_entity
        end         
    end    

    def destroy
        @evaluation_rule_detail = EvaluationRuleDetail.find(params[:id])
        @evaluation_rule_detail.destroy
        redirect_to evaluation_rule_details_path, notice: 'Item evaluación borrado correctamente', status: :see_other
    end     

    private

    def evaluation_rule_detail_params   
        params.require(:evaluation_rule_detail).permit(:score, :description, :evaluation_id, :observation, :meets,
        :fails, :apply, :standar_detail_item_id, :cycle, :item_nro, :order_nro, files: [])
    end 

end   

