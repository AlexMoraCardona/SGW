class MatrixDangerItem < ApplicationRecord
    belongs_to :matrix_danger_risk
    belongs_to :clasification_danger
    belongs_to :clasification_danger_detail
    belongs_to :location
    validates :deficiency_level, numericality: true
    validates :exposure_level, numericality: true
    validates :consequence_level, numericality: true


    def label_type_task(type)
        if type == 0 ; 'Rutinaria'
        elsif type == 1 ; 'No rutinaria'
        end 
    end      

    def label_si_no(dato)
        if dato == 0 ; 'No'
        elsif dato == 1 ; 'Si'
        end 
    end    

    def self.calculos(id_item)
        item = MatrixDangerItem.find(id_item)
        item.intervention_measures_elimination = DangerPrevention.buscar_medida(item.clasification_danger_detail_id,0)
        item.intervention_measures_replacement = DangerPrevention.buscar_medida(item.clasification_danger_detail_id,1)
        item.intervention_measures_engineering_control = DangerPrevention.buscar_medida(item.clasification_danger_detail_id,2)
        item.intervention_measures_acsw = DangerPrevention.buscar_medida(item.clasification_danger_detail_id,3)
        item.intervention_measures_ppee = DangerPrevention.buscar_medida(item.clasification_danger_detail_id,4)
        item.possible_effects_health = DangerDetailRisk.buscar_efecto(item.clasification_danger_detail_id)



        item.probability_level  = item.deficiency_level.to_f * item.exposure_level.to_f
        
        if item.probability_level.to_f <= 4 ; item.interpretation = 'BAJO'
        elsif item.probability_level.to_f <= 8 ; item.interpretation = 'MEDIO'
        elsif item.probability_level.to_f <= 20 ; item.interpretation = 'ALTO'
        elsif item.probability_level.to_f > 20 ; item.interpretation = 'MUY ALTO'
        end             
        
        item.level_risk_intervention = item.probability_level.to_f * item.consequence_level.to_f

        if item.level_risk_intervention.to_f <= 20 ; item.risk_level_interpretation = 'IV Aceptable'
        elsif item.level_risk_intervention.to_f <= 120 ; item.risk_level_interpretation = 'III Aceptable'
        elsif item.level_risk_intervention.to_f <= 500 ; item.risk_level_interpretation = 'II No Aceptable'
        elsif item.level_risk_intervention.to_f <= 4000 ; item.risk_level_interpretation = 'I No Aceptable'
        end             
 
        if item.risk_level_interpretation == "I No Aceptable" ; item.risk_acceptability = 'I No Aceptable situación critica, Suspender actividades hasta que el riesgo esté bajo control, la Intervención es urgente.'
        elsif item.risk_level_interpretation == "II No Aceptable" ; item.risk_acceptability = 'II No Aceptable Corregir y adoptar medidas de control inmediato, sin embargo se debe suspenda actividades si el nivel de consecuencia está por encima de 60.'
        elsif item.risk_level_interpretation == "III Aceptable" ; item.risk_acceptability = 'III Aceptable Mejorar si es posible.  Sería conveniente justificar la intervención y su rentabilidad. '
        elsif item.risk_level_interpretation == "IV Aceptable" ; item.risk_acceptability = 'IV Aceptable Mantener las medidas de control existentes, pero se deberían considerar soluciones o mejoras y se deben hacer comprobaciones periódicas para asegurar que el riesgo aún es tolerable'
        else  item.risk_acceptability = ""   
        end   
        
        if item.number_exposed_contrators.present? && item.number_exposed.present? ; item.number_exposed_totals = item.number_exposed_contrators + item.number_exposed  
        elsif item.number_exposed.present?; item.number_exposed_totals = item.number_exposed  
        else item.number_exposed_totals = item.number_exposed_contrators  
        end    
        
        item.save  
    end    
end
