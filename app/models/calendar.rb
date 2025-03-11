class Calendar < ApplicationRecord
    belongs_to :adm_calendar
    has_many :activities

    def self.crear_citar(n, id, vector)
        i = 0
        while i < n
            @activity_user = ActivityUser.new
            @activity_user.activity_id = id.to_i
            @activity_user.user_id = vector[i].to_i
            @user_cita = User.find(@activity_user.user_id) if @activity_user.user_id.present?
            @actividad_cita = Activity.find(@activity_user.activity_id) if @activity_user.activity_id.present?
            @calendario = Calendar.find(@actividad_cita.calendar_id) if @actividad_cita.calendar_id.present?
            @convoca = User.find(@actividad_cita.user_id) if @actividad_cita.present?
            @activity_user.mandatory  = 1
            @activity_user.save
 
            @mesnombre = Calendar.label_month(@calendario.month) if @calendario.present?
            if @actividad_cita.notify == 1 then
                UserMailer.with(user: @user_cita, reunion: @actividad_cita.description, lugar: @actividad_cita.place, observaciones: @actividad_cita.observation, hora: @actividad_cita.citation, dia: @calendario.day, nombredia: @calendario.name_day, mes: @calendario.month, nombremes: @mesnombre, año: @calendario.year, convocanombre: @convoca.name, convocacargo: @convoca.cargo_rol).citacion.deliver_later
            end                
            i = i + 1
        end        
    end

    def diasem(calendar)
        if calendar.name_day == "lunes" ; return 1;
        elsif  calendar.name_day == "martes" ; return 2;
        elsif  calendar.name_day == "miércoles" ; return 3;
        elsif  calendar.name_day == "jueves" ; return 4;
        elsif  calendar.name_day == "viernes" ; return 5;
        elsif  calendar.name_day == "sábado" ; return 6;
        elsif  calendar.name_day == "domingo" ; return 7;
        end 
    end     

    def hoy(calendar)
        if calendar.year == Date.today.year && calendar.month == Date.today.month && calendar.day == Date.today.day
            return 1;
        else    
            return 0;
        end    
    end


    def event(calendar)
        @activities = Activity.where("calendar_id = ?", calendar.id)
        if @activities.present?
            return 1;
        else    
            return 0;
        end    
    end

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

    def self.crear(adm_calendar)
        y = adm_calendar.year
        dia = adm_calendar.day_initial
        m = 1
        while m < 13
            if m == 1 || m == 3 || m == 5 || m == 7 || m == 8 || m == 10 || m == 12
                d = 1
                while d < 32
                    @calendar = Calendar.new
                    @calendar.day = d
                    @calendar.month = m
                    @calendar.year = y 
                    @calendar.adm_calendar_id = adm_calendar.id
                    @calendar.festive = 1 if dia == 7
                    if dia == 1; @calendar.name_day = 'lunes'
                    elsif dia == 2; @calendar.name_day = 'martes'
                    elsif dia == 3; @calendar.name_day = 'miércoles'
                    elsif dia == 4; @calendar.name_day = 'jueves'
                    elsif dia == 5; @calendar.name_day = 'viernes'
                    elsif dia == 6; @calendar.name_day = 'sábado'
                    elsif dia == 7; @calendar.name_day = 'domingo'
                    end
                    @calendar.save
                    if dia < 7
                        dia += 1
                    else
                         dia = 1 
                    end     
                    d = d + 1  
                end    
            elsif m == 4 || m == 6 || m == 9 || m == 11 
                d = 1
                while d < 31
                    @calendar = Calendar.new
                    @calendar.day = d
                    @calendar.month = m
                    @calendar.year = y 
                    @calendar.adm_calendar_id = adm_calendar.id
                    @calendar.festive = 1 if dia == 7
                    if dia == 1; @calendar.name_day = 'lunes'
                    elsif dia == 2; @calendar.name_day = 'martes'
                    elsif dia == 3; @calendar.name_day = 'miércoles'
                    elsif dia == 4; @calendar.name_day = 'jueves'
                    elsif dia == 5; @calendar.name_day = 'viernes'
                    elsif dia == 6; @calendar.name_day = 'sábado'
                    elsif dia == 7; @calendar.name_day = 'domingo'
                    end
                    @calendar.save
                    if dia < 7
                        dia += 1
                    else
                         dia = 1 
                    end     
                    d = d + 1  
                end    

            elsif m == 2    
                d = 1
                if adm_calendar.bisiesto == 0
                    feb = 29
                else
                    feb = 30
                end

                while d < feb
                    @calendar = Calendar.new
                    @calendar.day = d
                    @calendar.month = m
                    @calendar.year = y 
                    @calendar.adm_calendar_id = adm_calendar.id
                    @calendar.festive = 1 if dia == 7
                    if dia == 1; @calendar.name_day = 'lunes'
                    elsif dia == 2; @calendar.name_day = 'martes'
                    elsif dia == 3; @calendar.name_day = 'miércoles'
                    elsif dia == 4; @calendar.name_day = 'jueves'
                    elsif dia == 5; @calendar.name_day = 'viernes'
                    elsif dia == 6; @calendar.name_day = 'sábado'
                    elsif dia == 7; @calendar.name_day = 'domingo'
                    end
                    @calendar.save
                    if dia < 7
                        dia += 1
                    else
                         dia = 1 
                    end     
                    d = d + 1  
                end    
                
            end    

            m = m + 1
        end
    end   
    
    def self.notificaciones
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

            @activity_users = nil
            @activity_users = ActivityUser.where("user_id = ?", Current.user.id)
            if  @activity_users.present? then
                @activity_users.each do |activity_user| 
                    if activity_user.mandatory == 1 && activity_user.attended == 0 then
                        activity = Activity.find(activity_user.activity_id)
                        calendar = Calendar.find(activity.calendar_id)
                        fecha = calendar.year.to_s + "-" + calendar.month.to_s + "-" + calendar.day.to_s  if calendar.present?
                        @notificaciones << ["Citación", activity.entity.business_name, activity.description, fecha, activity.id]
                    end
                end   
            end
 
            @meeting_commitments = nil
            @meeting_commitments = MeetingCommitment.where("user_id = ?", Current.user.id)
            if  @meeting_commitments.present? then
                @meeting_commitments.each do |meeting_commitment| 
                    @notificaciones << ["Compromiso", meeting_commitment.meeting_minute.entity.business_name, meeting_commitment.commitment, meeting_commitment.date_commitment, meeting_commitment.id]
                end   
            end
        elsif
            if Current.user.level == 3 then
                @annual_work_plan = AnnualWorkPlan.find_by("year = ? and entity_id = ?", @year_noti,@entity.id) if @entity.present? 
                @annual_work_plan_items = nil
                if  @annual_work_plan.present? then
                        @annual_work_plan_items = AnnualWorkPlanItem.where("annual_work_plan_id = ? and earring = ?",@annual_work_plan.id,0)
                        if @annual_work_plan_items.present?
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

                @meeting_commitments = nil
                @meeting_commitments = MeetingCommitment.where("user_id = ?", Current.user.id)
                if  @meeting_commitments.present? then
                    @meeting_commitments.each do |meeting_commitment| 
                        @notificaciones << ["Compromiso", meeting_commitment.meeting_minute.entity.business_name, meeting_commitment.commitment, meeting_commitment.date_commitment, meeting_commitment.id]
                    end   
                end
    
            end

            @activity_users = nil
            @activity_users = ActivityUser.where("user_id = ?", Current.user.id)
            if  @activity_users.present? then
                @activity_users.each do |activity_user| 
                    if activity_user.mandatory == 1 && activity_user.attended == 0 then
                        activity = Activity.find(activity_user.activity_id)
                        calendar = Calendar.find(activity.calendar_id)
                        fecha = calendar.year.to_s + "-" + calendar.month.to_s + "-" + calendar.day.to_s  if calendar.present?
                        @notificaciones << ["Citación", activity.entity.business_name, activity.description, fecha, activity.id]
                    end
                end   
            end
        elsif
            if Current.user.level == 4 ||  Current.user.level == 5 then
                @commitments = Commitment.where("state_commitment = ? and user_id = ?",0,Current.user.id)
                if  @commitments.present? then
                    @commitments.each do |commitment|
                        @notificaciones << ["Compromiso Acta de Reunión COPASST - VIGÍA", commitment.evidence.entity.business_name, commitment.activity, commitment.date_ejecution, commitment.id]
                    end   
                end
            end    
        end 
        @cant_noti = @notificaciones.count if @notificaciones.present?
        return @notificaciones

    end    
end
