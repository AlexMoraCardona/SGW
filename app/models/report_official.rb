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

        #Calculo intervencio de peligros y riesgos gestionados
        matrix_danger_risks = MatrixDangerRisk.find_by(entity_id: @report_official.entity_id) if @report_official.present?
        matrix_danger_items = MatrixDangerItem.where('matrix_danger_risk_id = ?', matrix_danger_risks.id) if matrix_danger_risks.present?
        totalpeligrosriesgos = 0
        interpeligrosriesgos = 0
        if matrix_danger_items.present? 
            matrix_danger_items.each do |rep| 
                totalpeligrosriesgos += 1
                if rep.danger_intervened == 1 then
                    interpeligrosriesgos += 1
                end    
            end
        end    
        @report_official.risk_danger_ges = interpeligrosriesgos
        @report_official.risk_danger_total = totalpeligrosriesgos
        @report_official.risk_danger_gestion = (interpeligrosriesgos * 100)/ totalpeligrosriesgos if totalpeligrosriesgos > 0

        #Calculo Porcentaje de cobertura en capacitaciones
        training = Training.find_by(year: @report_official.year, entity_id: @report_official.entity_id)
        training_items = TrainingItem.where("training_id = ?",training.id) if training.present?
        totaltrainings = 0
        intertrainings = 0
        if training_items.present? 
            training_items.each do |rep| 
                totaltrainings += 1
                if rep.state_cap == 1 then
                    intertrainings += 1
                end    
            end
        end    
        @report_official.training_ges = intertrainings
        @report_official.training_total = totaltrainings
        @report_official.per_training_coverage = (intertrainings * 100)/ totaltrainings if totaltrainings > 0


        #Calculo Porcentaje de trabajadores capacitados
        training = Training.find_by(year: @report_official.year, entity_id: @report_official.entity_id)
        training_items = TrainingItem.where("training_id = ?",training.id) if training.present?
        scheduled_workers = 0
        trained_workers = 0
        if training_items.present? 
            training_items.each do |rep| 
                scheduled_workers += rep.cant_emple_cap if rep.state_cap != 2
                trained_workers += rep.cant_cap if rep.state_cap == 1
            end
        end    
        @report_official.trained_workers = trained_workers
        @report_official.scheduled_workers = scheduled_workers
        @report_official.per_scheduled_workers = (trained_workers * 100)/ scheduled_workers if scheduled_workers > 0


        #Calculo Autoevaluación del SG-SST
        evaluation = Evaluation.find_by(entity_id: @report_official.entity_id)
        evaluation_items = EvaluationRuleDetail.where("evaluation_id = ?",evaluation.id) if evaluation.present?
        items_autoevaluation_total = 0
        items_autoevaluation_cumple = 0

        if evaluation_items.present? 
            evaluation_items.each do |rep| 
                items_autoevaluation_total += 1 if rep.apply == 1 
                items_autoevaluation_cumple += 1 if rep.apply == 1 && rep.meets == 1
            end
        end    

        @report_official.items_autoevaluation_cumple = items_autoevaluation_cumple
        @report_official.items_autoevaluation_total = items_autoevaluation_total
        @report_official.per_autoevaluation = (items_autoevaluation_cumple * 100)/ items_autoevaluation_total if items_autoevaluation_total > 0


        #Ejecución de Acciones Preventivas AP, Acciones Correctivas AC, y de Mejora
        matrix_corrective_action = MatrixCorrectiveAction.find_by(entity_id: @report_official.entity_id) if @report_official.present?
        matrix_action_anual_items =  MatrixActionItem.where("matrix_corrective_action_id = ? and year = ?", matrix_corrective_action.id, @report_official.year) if matrix_corrective_action.present?
        acpm_total = 0
        acpm_cumple = 0

        if matrix_action_anual_items.present? then
            matrix_action_anual_items.each do |rep| 
                acpm_total += 1 
                acpm_cumple += 1 if rep.state_actions == 1 
            end
        end    

        @report_official.acpm_cumple = acpm_cumple
        @report_official.acpm_total = acpm_total
        @report_official.per_acpm = (acpm_cumple * 100)/ acpm_total if acpm_total > 0

        #Cumplimiento legal
        matrix_legal_anual = MatrixLegal.find_by(entity_id: @report_official.entity_id) if @report_official.present?
        matrix_legal_anual_items =  MatrixLegalItem.where("matrix_legal_id = ?", matrix_legal_anual.id) if matrix_legal_anual.present?
        compliance_legal_total = 0
        compliance_legal_cumple = 0

        if matrix_legal_anual_items.present? then
            matrix_legal_anual_items.each do |rep| 
                compliance_legal_total += 1 
                compliance_legal_cumple += 1 if rep.meets == 2 
            end
        end    

        @report_official.compliance_legal_cumple = compliance_legal_cumple
        @report_official.compliance_legal_total = compliance_legal_total
        @report_official.compliance_legal = (compliance_legal_cumple * 100)/ compliance_legal_total if compliance_legal_total > 0

        #Cumplimiento del plan de trabajo anual
        annual_work_plan = AnnualWorkPlan.find_by(entity_id: @report_official.entity_id, year: @report_official.year) if @report_official.present?
        annual_work_plan_items = AnnualWorkPlanItem.where("annual_work_plan_id = ?",annual_work_plan.id) if annual_work_plan.present? 
        compliance_work_plan_total = 0
        compliance_work_plan_cumple = 0

        if annual_work_plan_items.present? then
            annual_work_plan_items.each do |rep| 
                compliance_work_plan_total += 1 
                compliance_work_plan_cumple += 1 if rep.earring == 1 
            end
        end    

        @report_official.compliance_work_plan_cumple = compliance_work_plan_cumple
        @report_official.compliance_work_plan_total = compliance_work_plan_total
        @report_official.compliance_work_plan = (compliance_work_plan_cumple * 100)/ compliance_work_plan_total if compliance_work_plan_total > 0

        #Cumplimiento del plan de mejoramiento
        improvement_plan = ImprovementPlan.find_by(entity_id: @report_official.entity_id) if @report_official.present?
        improvement_items = ImprovementItem.where("improvement_plan_id = ?",improvement_plan.id) if improvement_plan.present? 
        activity_plan_total = 0
        activity_plan_intervenida = 0

        if improvement_items.present? then
            improvement_items.each do |rep| 
                activity_plan_total += 1 
                activity_plan_intervenida += 1 if rep.percentage_compliance == 100 
            end
        end    

        @report_official.activity_plan_intervenida = activity_plan_intervenida
        @report_official.activity_plan_total = activity_plan_total
        @report_official.per_activity_plan = (activity_plan_intervenida * 100)/ activity_plan_total if activity_plan_total > 0

        #Porcentaje de trabajadores que participaron en la encuesta de perfil sociodemográficos
        survey_profile = SurveyProfile.find_by(entity_id: @report_official.entity_id) if @report_official.present?
        cantencuestados = 0
        cantemp = 0
        if survey_profile.present? && survey_profile.date_profile.strftime("%Y").to_i == @report_official.year
            profiles = Profile.where(survey_profile_id: survey_profile.id) if survey_profile.present?
            cantemp = User.where("entity = ? and level > ? and state = ?", survey_profile.entity_id,2,1).count
            empleados = User.where("entity = ? and level > ? and state = ?", survey_profile.entity_id,2,1)
            cantencuestados = 0
            empleados.each do |empleado| 
                encontro = 0
                profiles.each do |profile|
                    if profile.user_id.to_i == empleado.id.to_i then
                        encontro = 1
                    end
                end    
                if encontro.to_i == 1 then
                    cantencuestados += 1 
                end    
            end    
        end    
        @report_official.perfil_sociodemo_encuestados = cantencuestados
        @report_official.perfil_sociodemo_total = cantemp
        @report_official.per_perfil_sociodemo = (cantencuestados * 100)/ cantemp if cantemp > 0

        @report_official.save
    end    

    def self.dias_incapacidad_accidentes(entity)
        año = Time.new.year 
        dias_incapacidad_accidentes = 0
        report_official = ReportOfficial.where("entity_id = ? and year = ?", entity, año) if entity.present?
        dias_incapacidad_accidentes =    report_official.sum("total_days_severidad_accidents") if report_official.present?
        return dias_incapacidad_accidentes
    end

    def self.enfermedad_laboral(entity)
        año = Time.new.year 
        enfermedad_laboral = 0
        report_official = ReportOfficial.where("entity_id = ? and year = ?", entity, año).last  if entity.present?

        enfermedad_laboral =    report_official.total_occupational_disease_year if report_official.present?
        return enfermedad_laboral
    end 
    
    def self.dias_comun_laboral(entity)
        año = Time.new.year 
        dias_comun_laboral = 0
        report_official = ReportOfficial.where("entity_id = ? and year = ?", entity, año) if entity.present?
        dias_comun_laboral =    report_official.sum("total_days_absenteeism") if report_official.present?
        return dias_comun_laboral
    end
    

end
