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
                session.delete(:user_id)      
            end
        end        
    end 
    
    def crear_evidencia
        @evidence = Evidence.new

        @evidence.entity_id = params[:entity_id]
        @evidence.evaluation_rule_detail_id = params[:evaluacion_rule_detail_id] 
        @evidence.template_id = params[:template_id]   
        @evidence.date = Time.now
        @evidence.compliances = "<strong>METAS:</strong> <br>Enumerar cada una de las metas que se establecerán para el cumplimiento del programa de capacitación anual; ejemplo:<br/>  <br>* Cobertura de trabajadores capacitados.<br/> <br>* Cumplimiento de actividades del cronograma.<br/> <br>* Evaluar los aprendizajes obtenidos en capacitaciones.<br/> <br>* Cumplimiento de requisitos legales.<br/>      <br><strong>ESTRATEGIAS:</strong><br/> <br>Enumerar cada una de las estrategias que se establecerán para el cumplimiento del programa de capacitación anual; ejemplo:<br/>  <br>*  Evaluación de necesidades basado en matriz de peligros y riesgos.<br/> <br>* Realización de encuesta a trabajadores.<br/> <br>* Material didáctico.<br/> <br>* Modalidad de capacitación mixta: presencial y virtual.<br/> <br>* Canales de comunicación.<br/>" if @evidence.template_id == 58 || @evidence.template_id == 59 || @evidence.template_id == 60
        @evidence.compliances = "<br>* Compromiso desde la Alta Dirección, en la implementación del Sistema de Gestión de Seguridad y Salud en el Trabajo, asignando los recursos humanos, tecnológicos y financieros, garantizando el cumplimiento de los objetivos.<br/> <br>*Prevenir accidentes y enfermedades laborales, como consecuencia a la exposición de los diferentes ambientes de trabajo de todos los empleados, contratistas, proveedores y visitantes.<br/> <br>*Dar cumplimiento a todas las disposiciones legales, Decretos, leyes, Resoluciones y demás normas que sean expedidas en materia de seguridad y salud en el trabajo; y a su vez, implementarlas y ejecutarlas al interior de la Organización.<br/> <br>*Establecer el principio de la mejora continua, en todos los procesos de aseguramiento de la Seguridad y Salud en el Trabajo.<br/> <br>*Fomentar el autocuidado y participación de todo el personal en materia de Seguridad y Salud en el trabajo.<br/> <br>*Promover la salud mental, con miras a que todos los empleados que integren la organización estén en ambientes de trabajo saludables.<br/> <br>*Compromiso con la mejora continua del SG-SST.<br/>" if @evidence.template_id == 64 || @evidence.template_id == 65 || @evidence.template_id == 66
        @evidence.compliances = "<br>* Desarrollar plan de capacitación y entrenamiento para el personal incluyendo demás partes interesadas.<br/> <br>* Proporcionar los recursos necesarios para la implementación del sistema de gestión de seguridad y salud en el trabajo.<br/> <br>* Identificar los diferentes peligros y riesgos y establecer controles específicos.<br/> <br>* Investigar accidentes, incidentes.<br/> <br>* Identificar y realizar seguimiento a los requisitos legales y aplicables.<br/> <br>* Cumplir con el plan de trabajo anual según el Decreto 1072 de 2015 Y mejora continua de este.<br/>" if @evidence.template_id == 67 || @evidence.template_id == 68 || @evidence.template_id == 69
        @evidence.compliances = "<br>* Examen médico ocupacional.<br/> <br>* Higiene postural.<br/> <br>* Pausas activas.<br/> <br>* Realización de pruebas complementarias.<br/> <br>* Remitir a EPS.<br/> <br>* Uso de elementos de protección personal.<br/> <br>* Continuar manejo médico<br/>" if @evidence.template_id == 115 || @evidence.template_id == 116 || @evidence.template_id == 117
        @texto = "<br>" if @evidence.template_id == 154 || @evidence.template_id == 155 || @evidence.template_id == 156

        if @evidence.template_id == 154 || @evidence.template_id == 155 || @evidence.template_id == 156 then
            @safety_inspection = SafetyInspection.where("entity_id = ?",@evidence.entity_id).last if @evidence.entity_id.present?
            @safety_inspection_items = SafetyInspectionItem.where("safety_inspection_id = ?", @safety_inspection.id) if @safety_inspection.present?
            @safety_inspection_items.each do |safety_inspection_item|
                if safety_inspection_item.state_compliance > 1
                    @texto = @texto.to_s + "<br>"
                    @texto = @texto.to_s + "<strong>" + safety_inspection_item.situation_condition.type_condition_inspection.name.to_s + "</strong>"
                    @texto = @texto.to_s + "<br>"
                    @texto = @texto.to_s + safety_inspection_item.situation_condition.name.to_s
                    @texto = @texto.to_s + "<br>"
                    @texto = @texto.to_s + "Observaciones: "
                    @texto = @texto.to_s + safety_inspection_item.observation.to_s 
                    @texto = @texto.to_s + "<br>"
                end
            end    
        end

        @evidence.compliances = @texto if @evidence.template_id == 154 || @evidence.template_id == 155 || @evidence.template_id == 156

        if @evidence.save then
            crear_firmas
            crear_participantes
            redirect_to edit_evaluation_rule_detail_path(params[:evaluacion_rule_detail_id]), notice: t('.created') 
        else
            render :edit, status: :unprocessable_entity
        end    
    end  
    
    def crear_firmas 
        if  @evidence.present? then
            user_legal_representative = User.find_by("entity = ? and legal_representative = ?", @evidence.entity_id.to_i, 1) 
            user_responsible = User.find(@evidence.entity.responsible_sst.to_i)  if @evidence.entity.responsible_sst.present? && @evidence.entity.responsible_sst.to_i > 0 
            user_asesor_externo = User.find(@evidence.entity.external_consultant.to_i)  if @evidence.entity.external_consultant.present? && @evidence.entity.external_consultant.to_i > 0 
            user_presidente_copasst = User.find_by("entity = ? and president_copasst = ?", @evidence.entity_id.to_i, 1) 
            user_secretario_copasst = User.find_by("entity = ? and secretary_copasst = ?", @evidence.entity_id.to_i, 1) 
            user_vigia = User.find_by("entity = ? and vigia_sgsst = ?", @evidence.entity_id.to_i, 1) 

            if user_legal_representative.present? && @evidence.template_id != 19 && @evidence.template_id != 20 && @evidence.template_id != 21 && @evidence.template_id != 22 && @evidence.template_id != 23 && @evidence.template_id != 24 && @evidence.template_id != 13 && @evidence.template_id != 14 && @evidence.template_id != 15 && @evidence.template_id != 7 && @evidence.template_id != 8 && @evidence.template_id != 9 && @evidence.template_id != 52 && @evidence.template_id != 53 && @evidence.template_id != 54 && @evidence.template_id != 115 && @evidence.template_id != 116 && @evidence.template_id != 117 && @evidence.template_id != 199 && @evidence.template_id != 200 && @evidence.template_id != 201 && @evidence.template_id != 223 && @evidence.template_id != 224 && @evidence.template_id != 225 && @evidence.template_id != 61 && @evidence.template_id != 62 && @evidence.template_id != 63 && @evidence.template_id != 58 && @evidence.template_id != 59 && @evidence.template_id != 60  then
                @firma_nueva  = Firm.new
                @firma_nueva.user_id = user_legal_representative.id
                @firma_nueva.legal_representative = 1
                @firma_nueva.evidence_id = @evidence.id
                @firma_nueva.post = 'Representante Legal'  
                @firma_nueva.save
            end   

            if user_presidente_copasst.present? && (@evidence.template_id == 34 || @evidence.template_id == 35 || @evidence.template_id == 36 || @evidence.template_id == 166 || @evidence.template_id == 167 || @evidence.template_id == 168 || @evidence.template_id == 199 || @evidence.template_id == 200 || @evidence.template_id == 201 || @evidence.template_id == 223 || @evidence.template_id == 224 || @evidence.template_id == 225) then
                @firma_nueva  = Firm.new
                @firma_nueva.user_id = user_presidente_copasst.id
                @firma_nueva.evidence_id = @evidence.id
                @firma_nueva.post = 'Presidente COPASST'  
                @firma_nueva.save
            end   

            if user_vigia.present? && (@evidence.template_id == 37 || @evidence.template_id == 38 || @evidence.template_id == 39 || @evidence.template_id == 166 || @evidence.template_id == 167 || @evidence.template_id == 168 || @evidence.template_id == 88 || @evidence.template_id == 89 || @evidence.template_id == 90 || @evidence.template_id == 223 || @evidence.template_id == 224 || @evidence.template_id == 225) then
                @firma_nueva  = Firm.new
                @firma_nueva.user_id = user_vigia.id
                @firma_nueva.evidence_id = @evidence.id
                @firma_nueva.post = 'Vigía SG-SST'  
                @firma_nueva.save
            end   

            if user_secretario_copasst.present? && (@evidence.template_id == 34 || @evidence.template_id == 35 || @evidence.template_id == 36 || @evidence.template_id == 166 || @evidence.template_id == 167 || @evidence.template_id == 168  || @evidence.template_id == 199 || @evidence.template_id == 200 || @evidence.template_id == 201 || @evidence.template_id == 223 || @evidence.template_id == 224 || @evidence.template_id == 225) then
                @firma_nueva  = Firm.new
                @firma_nueva.user_id = user_secretario_copasst.id
                @firma_nueva.evidence_id = @evidence.id
                @firma_nueva.post = 'Secretario(a) COPASST'  
                @firma_nueva.save
            end   

            if user_responsible.present? && (@evidence.template_id == 22 || @evidence.template_id == 23 || @evidence.template_id == 24 || @evidence.template_id == 43 || @evidence.template_id == 44 || @evidence.template_id == 45 || @evidence.template_id == 58 || 
                @evidence.template_id == 59 || @evidence.template_id == 60 || @evidence.template_id == 61 || @evidence.template_id == 62 || @evidence.template_id == 63 || @evidence.template_id == 70 || @evidence.template_id == 71 || @evidence.template_id == 72 || 
                @evidence.template_id == 4 || @evidence.template_id == 5 || @evidence.template_id == 6 || @evidence.template_id == 103 || @evidence.template_id == 104 || @evidence.template_id == 85 || @evidence.template_id == 86 || @evidence.template_id == 87 ||  
                @evidence.template_id == 105 || @evidence.template_id == 115 || @evidence.template_id == 116 || @evidence.template_id == 117 || 
                @evidence.template_id == 130 || @evidence.template_id == 131 || @evidence.template_id == 132 || @evidence.template_id == 136 || @evidence.template_id == 137 || 
                @evidence.template_id == 138 || @evidence.template_id == 151 || @evidence.template_id == 152 || @evidence.template_id == 153 || 
                @evidence.template_id == 175 || @evidence.template_id == 176 || @evidence.template_id == 177 || @evidence.template_id == 187 || @evidence.template_id == 188 || @evidence.template_id == 189 || @evidence.template_id == 190 || @evidence.template_id == 191 || 
                @evidence.template_id == 192 )   then
                @firma_nueva  = Firm.new
                @firma_nueva.user_id = user_responsible.id
                @firma_nueva.evidence_id = @evidence.id
                @firma_nueva.post = 'Responsable SG-SST'  
                @firma_nueva.save
            end 
            
            if user_asesor_externo.present? && (@evidence.template_id == 10 || @evidence.template_id == 11 || @evidence.template_id == 12 || @evidence.template_id == 61 || @evidence.template_id == 62 || @evidence.template_id == 63 || @evidence.template_id == 58 || @evidence.template_id == 59 || @evidence.template_id == 60 || 
                @evidence.template_id == 73 || @evidence.template_id == 74 || @evidence.template_id == 75 || @evidence.template_id == 82 || @evidence.template_id == 83 || @evidence.template_id == 84 || @evidence.template_id == 76 || @evidence.template_id == 77 || @evidence.template_id == 78 || @evidence.template_id == 79 || 
                @evidence.template_id == 80 || @evidence.template_id == 81 || @evidence.template_id == 133 || @evidence.template_id == 134 || @evidence.template_id == 135 || @evidence.template_id == 127 || @evidence.template_id == 128 || @evidence.template_id == 129 || @evidence.template_id == 118 || @evidence.template_id == 119 || 
                @evidence.template_id == 120 || @evidence.template_id == 121 || @evidence.template_id == 122 || @evidence.template_id == 123 || @evidence.template_id == 124 || @evidence.template_id == 125 || @evidence.template_id == 126 
                @evidence.template_id == 142 || @evidence.template_id == 143 || @evidence.template_id == 144 || @evidence.template_id == 145 || @evidence.template_id == 146 || @evidence.template_id == 147 || @evidence.template_id == 148 || @evidence.template_id == 149 || @evidence.template_id == 150 || @evidence.template_id == 226 || @evidence.template_id == 227 || 
                @evidence.template_id == 228 || @evidence.template_id == 154 || @evidence.template_id == 155 || @evidence.template_id == 156)  then
                @firma_nueva  = Firm.new
                @firma_nueva.user_id = user_asesor_externo.id
                @firma_nueva.evidence_id = @evidence.id
                @firma_nueva.post = 'Asesor Externo SG-SST'  
                @firma_nueva.save
            end 
            
        end    
    end    

    def crear_participantes

        if  @evidence.present? then
            entidad = Entity.find(@evidence.entity_id) if @evidence.present? 
            user_responsible = User.find(entidad.responsible_sst.to_i) if entidad.present? && entidad.responsible_sst.to_i > 0 
            user_representante_legal = User.find_by("entity = ? and legal_representative = ?", @evidence.entity_id.to_i, 1) 
            user_asesor_externo = User.find(entidad.external_consultant.to_i) if entidad.present? && entidad.external_consultant.to_i > 0 
            user_vigia = User.find_by("entity = ? and vigia_sgsst = ?", @evidence.entity_id.to_i, 1) 



            if user_vigia.present? && (@evidence.template_id == 37 || @evidence.template_id == 38 || @evidence.template_id == 39 || @evidence.template_id == 88 || @evidence.template_id == 89 || @evidence.template_id == 90)  then
                @participante_nuevo  = Participant.new
                @participante_nuevo.user_id = user_vigia.id
                @participante_nuevo.evidence_id = @evidence.id
                @participante_nuevo.post_copasst = 'Vigía SG-SST'  
                @participante_nuevo.vigia = 1
                @participante_nuevo.save
            end   

            if user_responsible.present? && (@evidence.template_id == 22 || @evidence.template_id == 23 || @evidence.template_id == 24 || @evidence.template_id == 4 || @evidence.template_id == 5 || @evidence.template_id == 6 || @evidence.template_id == 115 || @evidence.template_id == 116 || @evidence.template_id == 117 || @evidence.template_id == 85 || @evidence.template_id == 86 || @evidence.template_id == 87)  then
                @participante_nuevo  = Participant.new
                @participante_nuevo.user_id = user_responsible.id
                @participante_nuevo.evidence_id = @evidence.id
                @participante_nuevo.post_copasst = 'Responsable SG-SST'  
                @participante_nuevo.collaborator = 1
                @participante_nuevo.responsible_ssst = 1
                @participante_nuevo.save
            end   
            if user_asesor_externo.present? && (@evidence.template_id == 10 || @evidence.template_id == 11 || @evidence.template_id == 12)  then
                @participante_nuevo  = Participant.new
                @participante_nuevo.user_id = user_asesor_externo.id
                @participante_nuevo.evidence_id = @evidence.id
                @participante_nuevo.post_copasst = 'Asesor Externo SG-SST'  
                @participante_nuevo.external_consultant = 1
                @participante_nuevo.save
            end   

            
            if user_representante_legal.present? && (@evidence.template_id == 16 || @evidence.template_id == 17 || @evidence.template_id == 18 || @evidence.template_id == 4 || @evidence.template_id == 5 || @evidence.template_id == 6)  then
                @participante_nuevo  = Participant.new
                @participante_nuevo.user_id = user_representante_legal.id
                @participante_nuevo.evidence_id = @evidence.id
                @participante_nuevo.post_copasst = 'Representante Legal'  
                @participante_nuevo.collaborator = 1
                @participante_nuevo.save
            end   
            
        end    
    end    

    def crear_compromiso
        @commitment = Commitment.new
        @commitments = Commitment.where("evidence_id = ?", params[:id]) if params[:id].present?
        @evidence = Evidence.find(params[:id])
    end    

    def crear_firma
        @firm  = Firm.new  
        @firms = Firm.where("evidence_id = ?", params[:id]).decorate if params[:id].present?
        @evidence = Evidence.find(params[:id])
    end  
    
    def crear_participant
        @participant = Participant.new  
        @participants = Participant.where("evidence_id = ?", params[:id]) if params[:id].present?
        @evidence = Evidence.find(params[:id])
        @representante = User.find_by(entity: @evidence.entity_id, legal_representative: 1) if @evidence.present?
    end  
 
    def actualizar_evidencia
        @evidence = Evidence.find(params[:id])
    end    

    def ver_evidencia
        @evidence = Evidence.find(params[:id])
        @firms = Firm.where("evidence_id = ?", @evidence.id)
        @participants = Participant.where("evidence_id = ?", @evidence.id) if @evidence.present?
        @administrative_political_division = AdministrativePoliticalDivision.find(@evidence.entity.entity_location_code) if @evidence.entity.entity_location_code.present?
        @responsablesst = User.find(@evidence.entity.responsible_sst) if @evidence.entity.responsible_sst.present?
        @economic_activity = EconomicActivityCode.find(@evidence.entity.economic_activity)
        @arl = OccupationalRiskManager.find(@evidence.entity.entity_arl)
        @claseriesgo = RiskLevel.find(@evidence.entity.risk_classification) if @evidence.entity.risk_classification.present?
        @commitments = Commitment.where("evidence_id = ?", @evidence.id)
        @template = Template.find(@evidence.template_id) if @evidence.present?
        
        if @template.format_number == 77 
            @at = EvaluationRuleDetail.calculoat(@evidence.year_initial, @evidence.entity_id)
            @ca = EvaluationRuleDetail.calculoca(@evidence.year_initial, @evidence.entity_id)
            @el = EvaluationRuleDetail.calculoel(@evidence.year_initial, @evidence.entity_id)
            @cael = EvaluationRuleDetail.calculocael(@evidence.year_initial, @evidence.entity_id)

        end

        @firms.each do |firm| 
            @representante_legal = User.find(firm.user_id) if firm.legal_representative == 1 
        end  

        @participants.each do |participant| 
            @responsable_ssst = User.find(participant.user_id) if participant.responsible_ssst == 1 
            @asesor_externo_ssst = User.find(participant.user_id) if participant.external_consultant == 1 
            @colaborador_ssst = User.find(participant.user_id) if participant.collaborator == 1 && participant.person_complaining == 0 
            @cargo_colaborador = participant.post_copasst if participant.collaborator == 1 && participant.person_complaining == 0
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
        @evidences = Evidence.where("evaluation_rule_detail_id = ?", @evaluation_rule_detail.id).order(id: :desc)
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
                flash[:notice] = "Actualización Estándares"
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

