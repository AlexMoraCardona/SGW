class ReportOfficial < ApplicationRecord

    def self.label_month(month)
        if month == 1 ; 'enero'
        elsif  month == 2 ; 'febrero'
        elsif  month == 3 ; 'marzo'
        elsif  month == 4 ; 'abril'
        elsif  month == 5 ; 'mayo'
        elsif  month == 6 ; 'junio'
        elsif  month == 7 ; 'julio'
        elsif  month == 8 ; 'agosto'
        elsif  month == 9 ; 'septiembre'
        elsif  month == 10 ; 'octubre'
        elsif  month == 11 ; 'noviembre'
        elsif  month == 12 ; 'diciembre'
        end 
    end 

    def self.label_entidad(dato)
        Entity.find(dato).business_name if dato.present?
    end    


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
        cant = 0
        dato = 0
        report_official.each do |rep|
            cant += 1
            dato += rep.number_oficial 
        end    
       return (dato.to_f / cant.to_f) 
    end    

    def self.dato_number_oficial_independent(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.number_oficial_independent if rep.month == month 
        end    
       return dato 
    end    

    def self.promedio_number_oficial_independent(report_official)
        cant = 0
        dato = 0
        report_official.each do |rep|
            cant += 1
            dato += rep.number_oficial_independent 
        end    
        return (dato.to_f / cant.to_f)
    end    

    def self.dato_number_oficial_student(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.number_oficial_student if rep.month == month 
        end    
       return dato 
    end    

    def self.promedio_number_oficial_student(report_official)
        cant = 0
        dato = 0
        report_official.each do |rep|
            cant += 1
            dato += rep.number_oficial_student 
        end    
        return (dato.to_f / cant.to_f)
    end    


    def self.dato_number_oficial_temporary(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.number_oficial_temporary if rep.month == month 
        end    
       return dato 
    end    

    def self.promedio_number_oficial_temporary(report_official)
        cant = 0
        dato = 0
        report_official.each do |rep|
            cant += 1
            dato += rep.number_oficial_temporary 
        end    
        return (dato.to_f / cant.to_f) 
    end    

    def self.dato_number_oficial_cooperative(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.number_oficial_cooperative if rep.month == month 
        end    
       return dato 
    end    

    def self.promedio_number_oficial_cooperative(report_official)
        cant = 0
        dato = 0
        report_official.each do |rep|
            cant += 1
            dato += rep.number_oficial_cooperative 
        end    
        return (dato.to_f / cant.to_f) 
    end    

    def self.dato_number_oficial_other(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = rep.number_oficial_other if rep.month == month 
        end    
       return dato 
    end    

    def self.promedio_number_oficial_other(report_official)
        cant = 0
        dato = 0
        report_official.each do |rep|
            cant += 1
            dato += rep.number_oficial_other 
        end    
        return (dato.to_f / cant.to_f) 
    end    

    def self.dato_total_occupational_disease(report_official, mes)
        dato = 0
        report_official.each do |rep|
            dato = rep.total_occupational_disease if rep.month == mes 
        end    
    
        return dato 
    end    

    def self.dato_total_occupational_disease_final(report_official)
        dato = 0
        dato = report_official.first.total_occupational_disease 
        return dato
    end    

    def self.dato_total_occupational_disease_year(report_official, mes)
        dato = 0
        report_official.each do |rep|
            dato = rep.total_occupational_disease_year if rep.month == mes
        end    
        return dato 
    end    

    def self.dato_total_occupational_disease_year_final(report_official)
        dato = 0
        dato = report_official.first.total_occupational_disease_year
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
        dato = report_official.first.promedio_year_officials
        return dato
    end    

    def self.dato_total_dias_trabajo_programados(report_official, month)
        dato = 0
        report_official.each do |rep|
            dato = (rep.working_days_month * rep.total_officials) if rep.month == month 
        end    
       return dato 
    end    
  
    def self.sum_total_dias_trabajo_programados(report_official)
        suma_dato_working_days_month = 0
        report_official.each do |rep|
            suma_dato_working_days_month += (rep.working_days_month * rep.total_officials) 
        end    
       return  suma_dato_working_days_month
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
    
    
    def self.actuali_indicadores(repo_id) 
        @report_official = ReportOfficial.find(repo_id) 
        @events = Event.where("entity_id = ?", @report_official.entity_id)  
        @report_officials = ReportOfficial.where("entity_id = ? and year = ?", @report_official.entity_id, @report_official.year)
        @habil = BusinessDay.where("entity_id = ?", @report_official.entity_id)
        eventsmontwork_accident = 0
        eventsmontwork_accidentdays = 0
        eventsyearmortal_accident = 0
        eventsyearwork_accident = 0
        fechainicial =  Date.new(@report_official.year,@report_official.month,01) 
        fechafinal = fechainicial.end_of_month
        total_officials = 0
        total_work_accidents = 0
        total_mortal_accident = 0
        total_occupational_disease = 0
        total_laboral_inhability = 0
        total_common_inhability = 0
        total_days_absenteeism = 0 
        total_occupational_disease_year = 0
        dias_ausentismo = 0

        #Total de funcionarios en el mes
        total_officials = (@report_official.number_oficial + @report_official.number_oficial_cooperative + @report_official.number_oficial_independent + @report_official.number_oficial_other + @report_official.number_oficial_student + @report_official.number_oficial_temporary)
        #Promedio de funcionarios por año
        total_meses = 0
        acumulado_funcionarios = 0
        promedio = 0
        @report_officials.each do |rep|
            if rep.year == @report_official.year && rep.month <= @report_official.month then
               total_meses += 1  
               acumulado_funcionarios += (rep.number_oficial + rep.number_oficial_cooperative + rep.number_oficial_independent + rep.number_oficial_other + rep.number_oficial_student + rep.number_oficial_temporary)  
            end    
        end
        promedio = (acumulado_funcionarios.to_f / total_meses.to_f).round(2)    
        @events.each do |event|
            #Frecuencia de accidentalidad
            eventsmontwork_accident += 1 if (event.work_accident == 1 && event.date_new.month == @report_official.month && event.date_new.year == @report_official.year)   
            #Severidad de accidentalidad
            if event.disability_start_date.present? && event.disability_end_date.present? 
                if event.disability_start_date <=  fechafinal && event.disability_end_date >= fechainicial  
                    if event.work_accident == 1 then
                        if  event.disability_start_date.month == @report_official.month && event.disability_start_date.year == @report_official.year then
                            if event.disability_end_date.month == @report_official.month && event.disability_end_date.year == @report_official.year then
                                eventsmontwork_accidentdays  +=  (event.disability_end_date.day - event.disability_start_date.day) + 1   
                            else
                                eventsmontwork_accidentdays  +=  (event.disability_start_date.end_of_month.day - event.disability_start_date.day) + 1
                            end   
                        else
                            if event.disability_end_date.month == @report_official.month && event.disability_end_date.year == @report_official.year then
                                eventsmontwork_accidentdays  +=  (event.disability_end_date.day - fechainicial.day) + 1
                            else
                                eventsmontwork_accidentdays += (fechafinal.day -   fechainicial.day) + 1
                            end
                        end  
                    end 
                end
            end    
            #Proporcion de accidentes de trabajo mortales
            if event.work_accident == 1  then
                if  event.date_new.year == @report_official.year && event.date_new.month <= @report_official.month   then
                    eventsyearwork_accident += 1
                    if event.mortal_accident == 1 then
                        eventsyearmortal_accident += 1
                    end 
                end           
            end 
            #Prevalencia de la enfermedad laboral
            
            if event.occupational_disease == 1 && (event.date_new.year < @report_official.year || (event.date_new.year == @report_official.year && event.date_new.month <= @report_official.month)) then
                    total_occupational_disease += 1
            end 
            
            #Incidencia de la enfermedad laboral
            if event.occupational_disease == 1 && event.date_new.year == @report_official.year && event.date_new.month <= @report_official.month then
                total_occupational_disease_year += 1
            end 

            #Ausentismo   
            if event.disability_start_date.present? && event.disability_end_date.present? 
                if event.disability_start_date <=  fechafinal && event.disability_end_date >= fechainicial  
                    if event.laboral_inhability == 1 || event.common_inhability == 1  then
                        if  event.disability_start_date.month == @report_official.month && event.disability_start_date.year == @report_official.year then
                            if event.disability_end_date.month == @report_official.month && event.disability_end_date.year == @report_official.year then
                                fini = event.disability_start_date
                                ffin = event.disability_end_date
                                f = event.disability_start_date
                                while f <= ffin
                                    no_esta = 0
                                    if @habil.present? then
                                        @habil.each do |habil|
                                            if habil.date_skilled == f then
                                                no_esta = 1
                                            end  
                                        end
                                    end   
                                    if no_esta == 0 then     
                                        dias_ausentismo  += 1
                                    end    
                                    f += 1
                                end
                            else
                                fini = event.disability_start_date
                                ffin = event.disability_start_date.end_of_month
                                f = event.disability_start_date
                                while f <= ffin
                                    no_esta = 0
                                    if @habil.present? then
                                        @habil.each do |habil|
                                            if habil.date_skilled == f then
                                                no_esta = 1
                                            end  
                                        end 
                                    end    
                                    if no_esta == 0 then     
                                        dias_ausentismo  += 1
                                    end    
                                    f += 1
                                end
                            end   
                        else
                            if event.disability_end_date.month == @report_official.month && event.disability_end_date.year == @report_official.year then
                                fini = fechainicial
                                ffin = event.disability_end_date
                                f = fechainicial
                                while f <= ffin
                                    no_esta = 0
                                    if @habil.present? then
                                        @habil.each do |habil|
                                            if habil.date_skilled == f then
                                                no_esta = 1
                                            end  
                                        end 
                                    end    
                                    if no_esta == 0 then     
                                        dias_ausentismo  += 1
                                    end    
                                    f += 1
                                end
                            else
                                fini = fechainicial
                                ffin = fechafinal
                                f = fechainicial
                                while f <= ffin
                                    no_esta = 0
                                    if @habil.present? then
                                        @habil.each do |habil|
                                            if habil.date_skilled == f then
                                                no_esta = 1
                                            end  
                                        end 
                                    end    
                                    if no_esta == 0 then     
                                        dias_ausentismo  += 1
                                    end    
                                    f += 1
                                end
                            end
                        end  
                    end 
                end
            end
        end  
        
        @report_official.total_officials = total_officials 
        @report_official.frecuencia_accidentalidad = ((eventsmontwork_accident.to_f / total_officials.to_f) * 100).round(2) if total_officials > 0
        @report_official.total_work_accidents = eventsmontwork_accident
        @report_official.severidad_accidentalidad = ((eventsmontwork_accidentdays.to_f / total_officials.to_f) * 100).round(2) if total_officials  > 0
        @report_official.total_days_severidad_accidents = eventsmontwork_accidentdays  
        @report_official.proporcion_accidentes_mortales = ((eventsyearmortal_accident.to_f / eventsyearwork_accident.to_f) * 100).round(2) if eventsyearwork_accident > 0 
        @report_official.total_accidents_mortal_year = eventsyearmortal_accident
        @report_official.total_accidents_work_year = eventsyearwork_accident
        @report_official.total_occupational_disease = total_occupational_disease
        @report_official.promedio_year_officials = promedio.to_f
        @report_official.prevalencia_enfermedad_laboral = ((total_occupational_disease.to_f / promedio.to_f) * 100000).round(2) if promedio > 0  
        @report_official.total_occupational_disease_year = total_occupational_disease_year
        @report_official.incidencia_enfermedad_laboral = ((total_occupational_disease_year.to_f / promedio.to_f) * 100000).round(2) if promedio > 0  
        @report_official.total_days_absenteeism = dias_ausentismo 
        @report_official.ausentismo_causa_medica = ((dias_ausentismo.to_f / (@report_official.working_days_month.to_f * total_officials.to_f)) * 100).round(2) if total_officials > 0  
        @report_official.save
    end    


end
