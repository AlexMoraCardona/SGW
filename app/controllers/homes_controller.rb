class HomesController < ApplicationController
    def index 
         @calendars =  Calendar.where("year = ? and month >= ?", Date.today.year, Date.today.month).order(:day) 
         @activities = Activity.all.order(:citation)
         @entity = Entity.find(Current.user.entity) if Current.user.entity > 0 
         notificaciones
         calculo_porcentaje_general
         calculo_sex
         calculo_clasificacion_cargo
         accidentes_mortales
         dias_incapacidad_accidentes
         enfermedad_laboral
         dias_comun_laboral
         actos_inseguros
         peligros_riesgos
         capacitaciones

    end    

    def notificaciones 
        @entity = Entity.find(Current.user.entity) if Current.user.entity > 0
        @cant_noti = 0
        @noti = 0
        @year_noti = Date.today.year
        @notificaciones= []
        if Current.user.level == 1 || Current.user.level == 2 then
            @annual_work_plans = nil
            @annual_work_plan_items = nil
            @annual_work_plans = AnnualWorkPlan.where("year = ?", @year_noti)
            if  @annual_work_plans.present? then
                @annual_work_plans.each do |annual_work_plan| 
                    @annual_work_plan_items = AnnualWorkPlanItem.where("annual_work_plan_id = ? and earring = ?",annual_work_plan.id,0)
                    if @annual_work_plan_items.present?
                        @annual_work_plan_items.each do |item| 
                            fecha = item.date_realization.to_date 
                            @notificaciones << ["Plan anual de trabajo", annual_work_plan.entity.business_name, item.activity, fecha, item.id]
                        end    
                    end
                end   
            end
            @matrix_danger_risks = MatrixDangerRisk.all
            @matrix_danger_items = nil
            if  @matrix_danger_risks.present? then
                @matrix_danger_risks.each do |matrix_danger_risk| 
                    @matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ? and danger_intervened = ? and proposed_date <= ?",matrix_danger_risk.id,0,(Date.today + 30))
                    if @matrix_danger_items.present?
                        @matrix_danger_items.each do |item| 
                            @notificaciones << ["Matriz de Peligros y Riesgos", matrix_danger_risk.entity.business_name, item.activity, item.proposed_date, item.id]
                        end    
                    end
                end   
            end
            @matrix_corrective_actions = MatrixCorrectiveAction.all
            @matrix_action_items = nil
            if  @matrix_corrective_actions.present? then
                @matrix_corrective_actions.each do |matrix_corrective_action| 
                    @matrix_action_items = MatrixActionItem.where("matrix_corrective_action_id = ? and state_actions = ? and commitment_date <= ?",matrix_corrective_action.id,0,(Date.today + 30))
                    if @matrix_action_items.present?
                        @matrix_action_items.each do |item| 
                            @notificaciones << ["Matriz ACPM", matrix_corrective_action.entity.business_name, item.description_action, item.commitment_date, item.id]
                        end    
                    end
                end   
            end
            @matrix_conditions = MatrixCondition.all
            @matrix_unsafe_items = nil
            if  @matrix_conditions.present? then
                @matrix_conditions.each do |matrix_condition| 
                    @matrix_unsafe_items = MatrixUnsafeItem.where("matrix_condition_id = ? and state_unsafe = ?",matrix_condition.id,0)
                    if @matrix_unsafe_items.present?
                        @matrix_unsafe_items.each do |item| 
                            @notificaciones << ["Matriz Actos y Condiciones Inseguras", matrix_condition.entity.business_name, item.description_usafe, item.date_item, item.id]
                        end    
                    end
                end   
            end
            @commitments = Commitment.where("state_commitment = ?",0)
            if  @commitments.present? then
                @commitments.each do |commitment| 
                            @notificaciones << ["Compromiso Acta de Reunión COPASST - VIGÍA", commitment.evidence.entity.business_name, commitment.activity, commitment.date_ejecution, commitment.id]
                end   
            end
            @complaints = Complaint.where("state_complaint = ?",0)
            if  @complaints.present? then
                @complaints.each do |complaint| 
                            @notificaciones << ["Comité de Convivencia Laboral", complaint.entity.business_name, "Queja CCL", complaint.date_complaint, complaint.id]
                end   
            end

            @occupational_exam = nil
            @occupational_exam_items = nil
            @occupational_exams = OccupationalExam.all
            if  @occupational_exams.present? then
                @occupational_exams.each do |occupational_exam| 
                    @occupational_exam_items = OccupationalExamItem.where("occupational_exam_id = ? and state_exam = ?",occupational_exam.id,0)
                    if @occupational_exam_items.present?
                        @occupational_exam_items.each do |item| 
                            fecha = item.fec_venc.to_date 
                            @notificaciones << ["Exámenes Ocupacionales", occupational_exam.entity.business_name, item.name, fecha, item.id]
                        end    
                    end
                end   
            end


            @cant_noti = @notificaciones.count if @notificaciones.present?
        else
            @annual_work_plan = AnnualWorkPlan.find_by("year = ? and entity_id = ?", @year_noti,@entity.id) if @entity.present? 
            @annual_work_plan_items = nil
            if  @annual_work_plan.present? then
                    @annual_work_plan_items = AnnualWorkPlanItem.where("annual_work_plan_id = ? and earring = ?",@annual_work_plan.id,0)
                    if @annual_work_plan_items.presentAnnualWorkPlanItem?
                        @annual_work_plan_items.each do |item| 
                            fecha = item.date_realization 
                            @notificaciones << ["Plan anual de trabajo", @annual_work_plan.entity.business_name, item.activity, fecha.to_date, item.id]
                        end    
                    end
            end
            @matrix_danger_risk = MatrixDangerRisk.find_by(entity_id: @entity.id.to_i)
            @matrix_danger_items = nil
            if  @matrix_danger_risk.present? then
                    @matrix_danger_items = MatrixDangerItem.where("matrix_danger_risk_id = ? and danger_intervened = ? and proposed_date <= ?",@matrix_danger_risk.id,0,(Date.today+30))
                    if @matrix_danger_items.present?
                        @matrix_danger_items.each do |item| 
                            @notificaciones << ["Matriz de Peligros y Riesgos", @matrix_danger_risk.entity.business_name, item.activity, item.proposed_date, item.id]
                        end    
                    end
            end
            @matrix_corrective_action = MatrixCorrectiveAction.find_by(entity_id: @entity.id)
            @matrix_action_items = nil
            if  @matrix_corrective_action.present? then
                    @matrix_action_items = MatrixActionItem.where("matrix_corrective_action_id = ? and state_actions = ? and commitment_date <= ?",@matrix_corrective_action.id,0,(Date.today + 30))
                    if @matrix_action_items.present?
                        @matrix_action_items.each do |item| 
                            @notificaciones << ["Matriz ACPM", @matrix_corrective_action.entity.business_name, item.description_action, item.commitment_date, item.id]
                        end    
                    end
            end
            @matrix_condition = MatrixCondition.where("entity_id = ?",@entity.id).last
            @matrix_unsafe_items = nil
            if  @matrix_condition.present? then
                    @matrix_unsafe_items = MatrixUnsafeItem.where("matrix_condition_id = ? and state_unsafe = ?",@matrix_condition.id,0)
                    if @matrix_unsafe_items.present?
                        @matrix_unsafe_items.each do |item| 
                            @notificaciones << ["Matriz Actos y Condiciones Inseguras", @matrix_condition.entity.business_name, item.description_usafe, item.date_item, item.id]
                        end    
                    end
            end
            @commitments = Commitment.where("state_commitment = ?",0)
            if  @commitments.present? then
                @commitments.each do |commitment|
                    if commitment.evidence.entity_id ==  @entity.id then
                            @notificaciones << ["Compromiso Acta de Reunión COPASST - VIGÍA", commitment.evidence.entity.business_name, commitment.activity, commitment.date_ejecution, commitment.id]
                    end        
                end   
            end
            @complaints = Complaint.where("state_complaint = ? and entity_id = ?",0,@entity.id)
            if  @complaints.present? then
                @complaints.each do |complaint| 
                            @notificaciones << ["Comité de Convivencia Laboral", complaint.entity.business_name, "Queja CCL", complaint.date_complaint, complaint.id]
                end   
            end

            @occupational_exams = OccupationalExam.where("entity_id = ?", @entity.id) if @entity.present? 
            @occupational_exam_items = nil
            if  @occupational_exams.present? then
                @occupational_exams.each do |occupational_exam| 
                    @occupational_exam_items = OccupationalExamItem.where("occupational_exam_id = ? and state_exam = ?",occupational_exam.id,0)
                end    
                if @occupational_exam_items.present?
                    @occupational_exam_items.each do |item| 
                        fecha = item.fec_venc 
                        @notificaciones << ["Exámenes Ocupacionales", @entity.business_name, item.name, fecha, item.id]
                    end    
                end
            end


            @cant_noti = @notificaciones.count if @notificaciones.present?
            
        end 
        @notificaciones
    
        
    end    

    def calculo_porcentaje_general
            eval = Evaluation.where("entity_id = ?",@entity.id).last if @entity.present?
            details = EvaluationRuleDetail.where("evaluation_id = ? and apply = ?", eval.id, 1) if eval.present?
            total = 0
            cumple = 0
            por = 0.0
            @puntaje_eva = eval.score if eval.present?
            @porcentaje_eva = eval.percentage if eval.present?
            @result_eva = eval.result if eval.present?

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
            end    
    end 
    
    def calculo_sex
        users = User.where("entity = ? and state = ? and level > ?", @entity.id, 1, 2).order(:sex) if @entity.present?
        total = users.count if users.present?
        @datos_sex = []
        if users.present? then
            users.group_by(&:sex).each  do |niv, det|
                cant = 0
                det.each do |d|
                   cant += 1 
                end  
                por = ((cant.to_f / total.to_f) * 100).round(2).to_f if total.to_f > 0

                hom = "Hombres: " +  cant.to_s  if  niv.to_i == 0
                muj = "Mujeres: " + cant.to_s if  niv.to_i == 1
                @datos_sex.push([hom, por.to_f]) if  niv.to_i == 0
                @datos_sex.push([muj, por.to_f]) if  niv.to_i == 1
            end
        end    
    end     

    def calculo_clasificacion_cargo
        users = User.where("entity = ? and state = ? and level > ?", @entity.id, 1, 2).order(:clasification_post) if @entity.present?
        @total_colaboradores = 0
        @datos_clasificacion_cargo = []
        if users.present? then
            users.group_by(&:clasification_post).each  do |niv, det|
                cant = 0
                det.each do |d|
                    @total_colaboradores += 1 
                   cant += 1 
                end  
                adm = "Administrativos: " +  cant.to_s  if  niv.to_i == 0
                ope = "Operarios: " + cant.to_s if  niv.to_i == 1
                @datos_clasificacion_cargo.push([adm, cant]) if  niv.to_i == 0
                @datos_clasificacion_cargo.push([ope, cant]) if  niv.to_i == 1
            end
        end    
    end     

    def accidentes_mortales
        @accidentes_mortales = 0
        @accidentes_trabajo = 0
        año = Time.now.year
        @entity = Entity.find(Current.user.entity) if Current.user.entity > 0
        @events = Event.where("entity_id = ? ", @entity.id) if @entity.present?
        if @events.present?
            @events.each  do |event| 
                @accidentes_mortales += 1 if event.date_new.strftime("%Y").to_i == año && event.mortal_accident == 1   
                @accidentes_trabajo += 1 if event.date_new.strftime("%Y").to_i == año  && event.work_accident == 1
            end
        end
    end    

    def dias_incapacidad_accidentes
        entity = Entity.find(Current.user.entity) if Current.user.entity > 0
        año = Time.new.year 
        @dias_incapacidad_accidentes = 0
        report_official = ReportOfficial.where("entity_id = ? and year = ?", entity.id, año) if entity.present?
        @dias_incapacidad_accidentes =    report_official.sum("total_days_severidad_accidents") if report_official.present?

    end

    def enfermedad_laboral
        entity = Entity.find(Current.user.entity) if Current.user.entity > 0
        año = Time.new.year 
        @enfermedad_laboral = 0
        report_official = ReportOfficial.where("entity_id = ? and year = ?", entity.id, año).last  if entity.present?

        @enfermedad_laboral =    report_official.total_occupational_disease_year if report_official.present?

    end

    
    def dias_comun_laboral
        entity = Entity.find(Current.user.entity) if Current.user.entity > 0
        año = Time.new.year 
        @dias_comun_laboral = 0
        report_official = ReportOfficial.where("entity_id = ? and year = ?", entity.id, año) if entity.present?
        @dias_comun_laboral =    report_official.sum("total_days_absenteeism") if report_official.present?
    end

    def actos_inseguros
        entity = Entity.find(Current.user.entity) if Current.user.entity > 0
        @matrix_condition = MatrixCondition.find_by(entity_id: entity.id) if entity.present?
        @matrix_unsafe_items = nil
        @matrix_unsafe_items = MatrixUnsafeItem.where("matrix_condition_id = ?", @matrix_condition.id) if @matrix_condition.present?
        @cantidad = 0
        @cantidad = @matrix_unsafe_items.count if @matrix_unsafe_items.present?
        @totalactosinter = 0
        @totalactos = 0
        @totalactosnointer = 0
        @totalcondicionesinter = 0
        @totalcondiciones = 0
        @totalcondicionesnointer = 0

        if @cantidad > 0 then  
            @matrix_unsafe_items.each do |item|
                if item.clasification_unsafe == 1 
                    @totalactos += 1
                    @totalactosinter += 1 if item.state_unsafe == 1
                    @totalactosnointer += 1 if item.state_unsafe == 0
                end    
                if item.clasification_unsafe == 0 
                    @totalcondiciones += 1
                    @totalcondicionesinter += 1 if item.state_unsafe == 1
                    @totalcondicionesnointer += 1 if item.state_unsafe == 0
                end    
            end    
        end  
        
    end

    def peligros_riesgos
        entity = Entity.find(Current.user.entity) if Current.user.entity > 0
        @matrix_danger_items = nil
        @matrix_danger_risks = MatrixDangerRisk.find_by(entity_id: entity.id) if entity.present?
        @matrix_danger_items = MatrixDangerItem.where('matrix_danger_risk_id = ?', @matrix_danger_risks.id) if @matrix_danger_risks.present?

        @totalpeligrosinter = 0
        @totalpeligros = 0
        @datos_peligrosriesgos = []

        if @matrix_danger_items.present? then 
            @matrix_danger_items.each do |rep| 
                @totalpeligros += 1
                if rep.danger_intervened == 1 then
                    @totalpeligrosinter += 1
                end    
            end
        end    
    end

    def capacitaciones
        entity = Entity.find(Current.user.entity) if Current.user.entity > 0
        año = Time.new.year 
        training_items = nil
        training = Training.find_by(year: año, entity_id: entity.id) if entity.present?
        training_items = TrainingItem.where("training_id = ?",training.id) if training.present?
        total = training_items.count if training_items.present?

        @datos_capacitacion = []
        if training_items.present?
            training_items.group_by(&:state_cap).each  do |niv, det|
                cant = 0
                det.each do |d|
                   cant += 1 
                end  
                por = ((cant.to_f / total.to_f) * 100).round(2).to_f if total.to_f > 0

                pendientes = "Pendientes: " +  cant.to_s  if  niv.to_i == 0
                realizadas = "Realizadas: " + cant.to_s if  niv.to_i == 1
                canceladas = "Canceladas: " + cant.to_s if  niv.to_i == 2

                @datos_capacitacion.push([pendientes, por.to_f]) if  niv.to_i == 0
                @datos_capacitacion.push([realizadas, por.to_f]) if  niv.to_i == 1
                @datos_capacitacion.push([canceladas, por.to_f]) if  niv.to_i == 2
            end
        end    
    end     


    def show
         
    end    
end  