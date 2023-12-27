class ReportOfficial < ApplicationRecord

    def self.dato_total_work_accidents(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.total_work_accidents if rep.month == month 
        end    
       return dato 
    end    

    def self.suma_total_work_accidents(report_official)
        dato = 0
        report_official.each do |rep|
            dato += rep.total_work_accidents 
        end    
       return dato 
    end

    def self.dato_total_days_severidad_accidents(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.total_days_severidad_accidents if rep.month == month 
        end    
       return dato 
    end    

    def self.suma_total_days_severidad_accidents(report_official)
        dato = 0
        report_official.each do |rep|
            dato += rep.total_days_severidad_accidents 
        end    
       return dato 
    end    

    def self.dato_total_days_absenteeism(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.total_days_absenteeism if rep.month == month 
        end    
       return dato 
    end    

    def self.suma_total_days_absenteeism(report_official)
        dato = 0
        report_official.each do |rep|
            dato += rep.total_days_absenteeism 
        end    
       return dato 
    end    

    def self.dato_working_days_month(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.working_days_month if rep.month == month 
        end    
       return dato 
    end    

    def self.suma_working_days_month(report_official)
        dato = 0
        report_official.each do |rep|
            dato += rep.working_days_month 
        end    
       return dato 
    end    

    def self.dato_number_oficial(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.number_oficial if rep.month == month 
        end    
       return dato 
    end    

    def self.promedio_number_oficial(report_official)
        dato = 0
        report_official.each do |rep|
            dato += rep.number_oficial 
        end    
       return (dato / 12) 
    end    

    def self.dato_number_oficial_independent(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.number_oficial_independent if rep.month == month 
        end    
       return dato 
    end    

    def self.promedio_number_oficial_independent(report_official)
        dato = 0
        report_official.each do |rep|
            dato += rep.number_oficial_independent 
        end    
       return (dato / 12) 
    end    

    def self.dato_number_oficial_student(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.number_oficial_student if rep.month == month 
        end    
       return dato 
    end    

    def self.promedio_number_oficial_student(report_official)
        dato = 0
        report_official.each do |rep|
            dato += rep.number_oficial_student 
        end    
       return (dato / 12) 
    end    


    def self.dato_number_oficial_temporary(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.number_oficial_temporary if rep.month == month 
        end    
       return dato 
    end    

    def self.promedio_number_oficial_temporary(report_official)
        dato = 0
        report_official.each do |rep|
            dato += rep.number_oficial_temporary 
        end    
       return (dato / 12) 
    end    

    def self.dato_number_oficial_cooperative(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.number_oficial_cooperative if rep.month == month 
        end    
       return dato 
    end    

    def self.promedio_number_oficial_cooperative(report_official)
        dato = 0
        report_official.each do |rep|
            dato += rep.number_oficial_cooperative 
        end    
       return (dato / 12) 
    end    

    def self.dato_number_oficial_other(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.number_oficial_other if rep.month == month 
        end    
       return dato 
    end    

    def self.promedio_number_oficial_other(report_official)
        dato = 0
        report_official.each do |rep|
            dato += rep.number_oficial_other 
        end    
       return (dato / 12) 
    end    

    def self.dato_total_occupational_disease(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.total_occupational_disease if rep.month == month 
        end    
       return dato 
    end    

    def self.dato_total_occupational_disease_year(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.total_occupational_disease_year if rep.month == month 
        end    
       return dato 
    end    

    def self.dato_total_officials(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.total_officials if rep.month == month 
        end    
       return dato 
    end    

    def self.pro_total_officials(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.promedio_year_officials if rep.month == month
        end    
       return dato 
    end    

    def self.dato_total_dias_trabajo_programados(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = (rep.working_days_month * rep.total_officials) if rep.month == month 
        end    
       return dato 
    end    

    def self.pro_total_dias_trabajo_programados(report_official)
        suma_dato_working_days_month = 0
        dato = 0
        result = 0
        report_official.each do |rep|
            suma_dato_working_days_month += rep.working_days_month 
            dato = rep.promedio_year_officials if rep.month == 12
        end    
        result = (suma_dato_working_days_month * dato ) if dato > 0
       return  result
    end    

    def self.dato_frecuencia_accidentalidad(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.frecuencia_accidentalidad if rep.month == month 
        end    
       return dato 
    end    

    def self.pro_frecuencia_accidentalidad(report_official)
        dato = 0
       return dato 
    end    

    def self.dato_severidad_accidentalidad(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.severidad_accidentalidad if rep.month == month 
        end    
       return dato 
    end    

    def self.pro_severidad_accidentalidad(report_official)
        dato = 0
       return dato 
    end    

    def self.dato_ausentismo_causa_medica(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.ausentismo_causa_medica if rep.month == month 
        end    
       return dato 
    end    

    def self.pro_ausentismo_causa_medica(report_official)
        dato = 0
       return dato 
    end    

    def self.dato_prevalencia_enfermedad_laboral(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.prevalencia_enfermedad_laboral if rep.month == month 
        end    
       return dato 
    end    

    def self.pro_prevalencia_enfermedad_laboral(report_official)
        dato = 0
       return dato 
    end    

    def self.dato_incidencia_enfermedad_laboral(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.incidencia_enfermedad_laboral if rep.month == month 
        end    
       return dato 
    end    

    def self.pro_incidencia_enfermedad_laboral(report_official)
        dato = 0
       return dato 
    end    

    def self.dato_proporcion_accidentes_mortales(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.proporcion_accidentes_mortales if rep.month == month 
        end    
       return dato 
    end    

    def self.pro_proporcion_accidentes_mortales(report_official)
        dato = 0
       return dato 
    end    

end
