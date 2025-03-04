class Evaluation < ApplicationRecord

    belongs_to :entity
    belongs_to :risk_level
    belongs_to :rule
    has_many :meeting_minutes
    has_rich_text :observation


    def self.ransackable_attributes(auth_object = nil)
        ["meets", "standar_detail_item_id", "cycle", "item_nro"]
    end 

    def self.ransackable_associations(auth_object = nil)
        []
    end     

    def calculo_porcentaje_ciclo(id_evaluacion)
        eval = Evaluation.find(id_evaluacion)
        details = EvaluationRuleDetail.where("evaluation_id = ? and apply = ?", eval.id, 1)
        total = 0
        cumple = 0
        por = 0.0
        datos_generales = []
        ciclo = 0
        details.group_by(&:cycle).each do |cic, det|
            ciclo = 0
            total = 0
            cumple = 0
            por = 0
            det.each do |d|
               total += 1
               cumple += 1 if d.meets > 0 
               ciclo = cic  
            end    
                
            por = ((cumple.to_f / total.to_f) * 100).round(2).to_f if total.to_f > 0
            
            datos_generales.push(["Planificar", por.to_f]) if total.to_i > 0 && ciclo.to_i == 1
            datos_generales.push(["Hacer", por.to_f]) if total.to_i > 0 && ciclo.to_i == 2
            datos_generales.push(["Verificar", por.to_f]) if total.to_i > 0 && ciclo.to_i == 3
            datos_generales.push(["Actuar", por.to_f]) if total.to_i > 0 && ciclo.to_i == 4
        end
        return datos_generales 
    end 

    def calculo_pendientes_evaluacion(id_evaluacion)
        eval = Evaluation.find(id_evaluacion)
        details = EvaluationRuleDetail.where("evaluation_id = ? and apply = ?", eval.id, 1)
          
        pendientes = 0
        datos_pendientes = []
        ciclo = 0
        details.group_by(&:cycle).each do |cic, det|
            ciclo = 0
            pendientes = 0
            det.each do |d|
               pendientes += 1 if d.meets == 0
               ciclo = cic  
            end    
                
            datos_pendientes.push(["Planificar", pendientes]) if  ciclo.to_i == 1
            datos_pendientes.push(["Hacer", pendientes]) if  ciclo == 2.to_i
            datos_pendientes.push(["Verificar", pendientes]) if  ciclo.to_i == 3
            datos_pendientes.push(["Actuar", pendientes]) if  ciclo.to_i == 4
        end
        return  datos_pendientes 
    end

    def calculo_cumplidos_evaluacion(id_evaluacion)
        eval = Evaluation.find(id_evaluacion)
        details = EvaluationRuleDetail.where("evaluation_id = ? and apply = ?", eval.id, 1)
          
        cumplidos = 0
        datos_cumplidos = []
        ciclo = 0
        details.group_by(&:cycle).each do |cic, det|
            ciclo = 0
            cumplidos = 0
            det.each do |d|
                cumplidos += 1 if d.meets > 0
               ciclo = cic  
            end     
                
            datos_cumplidos.push(["Planificar", cumplidos.to_i]) if  ciclo.to_i == 1
            datos_cumplidos.push(["Hacer", cumplidos.to_i]) if  ciclo.to_i == 2
            datos_cumplidos.push(["Verificar", cumplidos.to_i]) if  ciclo.to_i == 3
            datos_cumplidos.push(["Actuar", cumplidos.to_i]) if  ciclo.to_i == 4
        end
        return  datos_cumplidos 
    end

    def self.new_evaluation(standar_detail_items, evaluation)
        @cont = 0
        standar_detail_items.each do |item|
            @item = EvaluationRuleDetail.new
            @item.score = 0
            @item.description = item.description
            @item.evaluation_id = evaluation.id
            @item.standar_detail_item_id = item.id
            @item.apply = item.aplica
            @item.meets = 0
            @item.maximun_value = item.maximun_value
            @item.cycle = item.standar_detail.standar.cycle
            @item.score = @item.maximun_value if item.aplica == 0
            @item.order_nro = item.order_nro
            @cont += 1 
            @item.save
        end          
    end    

    def self.new_history(evaluation, evaluation_items)
        @history_evaluation = HistoryEvaluation.new
        @history_evaluation.date_create_evaluation  = evaluation.date_evaluation
        @history_evaluation.date_history_evaluation  = Time.now 
        @history_evaluation.number_employees  = evaluation.number_employees
        @history_evaluation.score  = evaluation.score
        @history_evaluation.percentage  = evaluation.percentage
        @history_evaluation.score_int  = evaluation.score_int
        @history_evaluation.percentage_int  = evaluation.percentage_int
        @history_evaluation.result  = evaluation.result
        @history_evaluation.rule_id  = evaluation.rule_id
        @history_evaluation.risk_level_id  = evaluation.risk_level_id
        @history_evaluation.evaluation_id  = evaluation.id
        @history_evaluation.entity_id  = evaluation.entity_id
        @history_evaluation.id_employee_contractor = 1
        @history_evaluation.expected_goald = evaluation.expected_goald
        @history_evaluation.id_employee_contractor = evaluation.user_representante
        @history_evaluation.firm_employee_contractor = evaluation.firm_representante
        @history_evaluation.date_firm_employee = evaluation.date_firm_representante
        @history_evaluation.id_responsible_execution = evaluation.user_responsible
        @history_evaluation.firm_responsible_execution = evaluation.firm_responsible
        @history_evaluation.date_firm_responsible = evaluation.date_firm_responsible

        if @history_evaluation.result == "CRÍTICO" then
            @history_evaluation.observation = "Plan de Mejoramiento de inmediato a disposición de MinTrabajo.  Enviar a la ARL reporte de avances ( máx a los tres meses).  Seguimiento anual y Plan de Visita la empresa por parte del Ministerio."
        end 
        if @history_evaluation.result == "MODERADAMENTE ACEPTABLE" then
            @history_evaluation.observation = "Plan de Mejoramiento a disposición de MinTrabajo.  Enviar a la ARL reporte de avances (max a los seis meses).  Plan de visita MinTrabajo."
        end 

        if @history_evaluation.result == "ACEPTABLE" then
            @history_evaluation.observation = "Mantener la calificación y evidencias a disposición de MinTrabajo.  Incluir en el Plan de Anual de Trabajo las mejoras que se establezcan de acuerdo con la evaluación."
        end 

        evaluation_items.each do |item|
            @history_evaluation.completed_items  += 1 if item.meets == 1
            @history_evaluation.unfulfilled_items  += 1 if item.meets == 0
            @history_evaluation.not_apply_items += 1 if item.apply == 0
        end    
        
        @history_evaluation.save 
            
        evaluation_items.each do |item|        
            @history_item  = HistoryItem.new 
            @history_item.score  = item.score
            @history_item.description = item.description
            @history_item.observation = item.observation
            @history_item.apply = item.apply
            @history_item.meets = item.meets
            @history_item.cycle = item.cycle
            @history_item.item_nro = item.item_nro
            @history_item.order_nro = item.order_nro
            @history_item.evaluation_rule_detail_id = item.id
            @history_item.history_evaluation_id = @history_evaluation.id
            @history_item.save
        end    
    end     
    def calculo_porcentaje_general(id_evaluacion)
        eval = Evaluation.find(id_evaluacion)
        details = EvaluationRuleDetail.where("evaluation_id = ? and apply = ?", eval.id, 1) if eval.present?
        total = 0
        cumple = 0
        por = 0.0
        datos_generales = []
        details.each do |d|
            total += 1
            cumple += 1 if d.meets > 0 
                
        end
        por = ((cumple.to_f / total.to_f) * 100).round(2).to_f if total.to_f > 0
        
        cumpli = "Estándares Cumplidos: " +  cumple.to_s
        pendi = "Estándares Pendientes: " + (total.to_i - cumple.to_i).to_s
        datos_generales.push([cumpli, por.to_f]) if total.to_i > 0 
        datos_generales.push([pendi, (100 - por.to_f)]) if total.to_i > 0 
        return datos_generales 
    end 


    def name_user(user_id)
        name = 'No encontrado'
        if user_id > 0
            user =  User.find(user_id)
            name = user.name
        end    
        return  name 
    end

    def label_firm(firm)
        if firm == 0 ; 'NO'
        elsif  firm == 1 ; 'SI'
        end 
    end  

    def self.calculo_porcentaje_general(eval) 
        details = EvaluationRuleDetail.where("evaluation_id = ? and apply = ?", eval.id, 1) if eval.present?
        total = 0
        cumple = 0
        por = 0.0

        @datos_generales = []
        if details.present?
            details.each do |d|
                total += 1
                cumple += 1 if d.meets > 0 
                
            end
            por = ((cumple.to_f / total.to_f) * 100).round(2).to_f if total.to_f > 0
        
            cumpli = "Cumplidos: " +  cumple.to_s
            pendi = "Pendientes: " + (total.to_i - cumple.to_i).to_s
            @datos_generales.push([cumpli, por.to_f]) if total.to_i > 0 
            @datos_generales.push([pendi, (100 - por.to_f)]) if total.to_i > 0 
            @datos_generales
        end 
        return @datos_generales  
    end 

    def self.calculo_variables(id_evaluacion)
        eval = Evaluation.find(id_evaluacion)
        details = EvaluationRuleDetail.where("evaluation_id = ?", eval.id)
        total_score = 0
        total_details = 0
        total_details_cumplidos = 0
        result = ''
        total_score_int = 0
        total_details_cumplidos_int = 0

        #@score_max_eval = 0
        details.each do |detail| 

            if detail.apply == 0
                total_score += detail.maximun_value
                total_details_cumplidos += 1 
                total_score_int += detail.score  if detail.meets == 1
                total_details_cumplidos_int += 1 if detail.meets == 1
            end

            if detail.apply == 1
                total_score += detail.score  if detail.meets == 1   
                total_details_cumplidos += 1 if detail.meets == 1
                total_score_int += detail.score  if detail.meets == 1   
                total_details_cumplidos_int += 1 if detail.meets == 1                
            end
            
            #@score_max_eval += detail.maximun_value 
            total_details += 1
            
        end 
        eval.score  = total_score
        eval.percentage =  ((total_details_cumplidos.to_f / total_details.to_f) * 100).round(2) if total_details.to_f > 0
        eval.score_int  = total_score_int
        eval.percentage_int =  ((total_details_cumplidos_int.to_f / total_details.to_f) * 100).round(2) if total_details.to_f > 0


        if eval.score < 61 then
           eval.result = "CRÍTICO"
           eval.observation = "<br>* Plan de Mejoramiento de inmediato a disposición de MinTrabajo.<br/> <br>* Enviar a la ARL reporte de avances ( máx a los tres meses).<br/> <br>* Seguimiento anual y Plan de Visita la empresa por parte del Ministerio.<br/>"
        end 
        if eval.score > 60.99 && eval.percentage < 86 then
            eval.result = "MODERADAMENTE ACEPTABLE"
            eval.observation = "<br>* Plan de Mejoramiento a disposición de MinTrabajo.<br/> <br>* Enviar a la ARL reporte de avances (max a los seis meses).<br/> <br>* Plan de visita MinTrabajo.<br/>"
        end 
      
        if eval.score > 85.99 then
            eval.result = "ACEPTABLE"
            eval.observation = "<br>* Mantener la calificación y evidencias a disposición de MinTrabajo.<br/> <br>* Incluir en el Plan de Anual de Trabajo las mejoras que se establezcan de acuerdo con la evaluación.<br/>"
        end 
        
        eval.save
            
            
    end


end
