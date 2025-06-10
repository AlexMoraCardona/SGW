class MatrixGoal < ApplicationRecord
    belongs_to :entity

    def name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end
    
    def label_firm(firm)
        if firm == 0 ; 'NO'
        elsif  firm == 1 ; 'SI'
        end 
    end  


    def self.label_dato(indicador, report_official)
       dato = 'No encontrado'
       if indicador == 1 ;  dato = report_official.frecuencia_accidentalidad
       elsif indicador == 2 ; dato = report_official.severidad_accidentalidad
       elsif indicador == 3 ; dato = report_official.proporcion_accidentes_mortales
       elsif indicador == 4 ; dato = report_official.prevalencia_enfermedad_laboral
       elsif indicador == 5 ; dato = report_official.incidencia_enfermedad_laboral
       elsif indicador == 6 ; dato = report_official.ausentismo_causa_medica
       elsif indicador == 7 ; dato = report_official.risk_danger_gestion
       elsif indicador == 8 ; dato = report_official.per_training_coverage
       elsif indicador == 9 ; dato = report_official.trained_workers
       elsif indicador == 10 ; dato = report_official.per_autoevaluation
       elsif indicador == 11 ; dato = report_official.per_acpm
       elsif indicador == 13 ; dato = report_official.compliance_legal
       elsif indicador == 14 ; dato = report_official.compliance_work_plan
       elsif indicador == 15 ; dato = report_official.per_activity_plan
       elsif indicador == 16 ; dato = report_official.per_perfil_sociodemo
       end
       return dato;
    end
end
