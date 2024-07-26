class Evaluation < ApplicationRecord

    belongs_to :entity
    belongs_to :risk_level
    belongs_to :rule
    has_many :meeting_minutes
    has_rich_text :observation


    
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
            @item.meets = 2 if item.aplica == 0
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
        @history_evaluation.result  = evaluation.result
        @history_evaluation.observation  = evaluation.observation
        @history_evaluation.rule_id  = evaluation.rule_id
        @history_evaluation.risk_level_id  = evaluation.risk_level_id
        @history_evaluation.evaluation_id  = evaluation.id
        @history_evaluation.entity_id  = evaluation.entity_id
        @history_evaluation.id_employee_contractor = 1
        evaluation_items.each do |item|
            @history_evaluation.completed_items  += 1 if item.meets == 1
            @history_evaluation.unfulfilled_items  += 1 if item.meets == 0
            @history_evaluation.not_apply_items += 1 if item.meets == 2
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
        details = EvaluationRuleDetail.where("evaluation_id = ? and apply = ?", eval.id, 1)
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

end
