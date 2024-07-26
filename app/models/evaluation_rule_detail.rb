class EvaluationRuleDetail < ApplicationRecord
    has_many_attached :files
    has_many :templates

    #has_one_attached :file
    include PgSearch::Model
    pg_search_scope :search_by_id, against: :evaluation_id
    pg_search_scope :search_full_text, against: {
        evaluation_id: 'A'
    }
    belongs_to :evaluation
    belongs_to :standar_detail_item

    def label_cycle
        if evaluation_items.standar_detail_item.standar_detail.standar.cycle == 1 ; 'Planificar'
        elsif evaluation_items.standar_detail_item.standar_detail.standar.cycle == 2 ; 'Hacer'
        elsif evaluation_items.standar_detail_item.standar_detail.standar.cycle == 3 ; 'Verificar'
        elsif evaluation_items.standar_detail_item.standar_detail.standar.cycle == 4 ; 'Actuar'
        end 
    end

    def self.calculo_variables(id_evaluacion)
        eval = Evaluation.find(id_evaluacion)
        details = EvaluationRuleDetail.where("evaluation_id = ?", eval.id)
        total_score = 0
        total_details = 0
        total_details_cumplidos = 0
        result = ''
        @score_max_eval = 0
        details.each do |detail| 
            total_score += detail.score
            @score_max_eval += detail.maximun_value 
            total_details += 1
            total_details_cumplidos += 1 if detail.meets > 0
        end 
        eval.score  = total_score
        eval.percentage =  ((total_details_cumplidos.to_f / total_details.to_f) * 100).round(2) if total_details.to_f > 0

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
    
    def self.miles(valor)
        cadena = valor.to_s
        n = cadena.length
        i = 0
        separador = 0
        nuevodato = ''
        while i < n
            separador = n - i
            if separador == 4 || separador == 7 || separador == 10 || separador == 13 || separador == 16 
                nuevodato << cadena[i]
                nuevodato << "."
            else 
                nuevodato << cadena[i]
            end 
            i += 1
        end  
        return nuevodato;
    end

    def self.label_meets(dato)
        if dato == 0 ; 'NO'
        elsif dato == 1 ; 'SI'
        elsif dato == 1 ; 'NA'
        end 
    end 

end
