class Firm < ApplicationRecord
    belongs_to :user
    belongs_to :evidence

    def self.penfirma
        @firmas_pendientes  =  Firm.where("user_id = ? and authorize_firm = ?",Current.user.id,0)
        @actas_pendientes = Assistant.where("user_id = ? and firm_assistant = ?",Current.user.id,0)  
        @description_jobs = DescriptionJob.where("user_elaboro = ? and firm_elaboro = ? or user_reviso = ? and firm_reviso = ? or user_aprobo = ? and firm_aprobo = ?",Current.user.id,0,Current.user.id,0,Current.user.id,0)  
        @resources = Resource.where("user_legal_representative = ? and firm_legal_representative = ? or user_adviser_sst = ? and firm_adviser_sst = ?",Current.user.id,0,Current.user.id,0)  
        @matrix_conditions = MatrixCondition.where("user_representante = ? and firm_representante = ? or user_responsible = ? and firm_responsible = ?",Current.user.id,0,Current.user.id,0)  
        @matrix_protections = MatrixProtection.where("user_legal_representative = ? and firm_legal_representative = ? or user_adviser_sst = ? and firm_adviser_sst = ? or user_responsible_sst = ? and firm_responsible_sst = ?",Current.user.id,0,Current.user.id,0,Current.user.id,0)  
        @matrix_legals = MatrixLegal.where("user_legal_representative = ? and firm_legal_representative = ? or user_adviser_sst = ? and firm_adviser_sst = ? or user_responsible_sst = ? and firm_responsible_sst = ?",Current.user.id,0,Current.user.id,0,Current.user.id,0)  
        @matrix_goals = MatrixGoal.where("user_representante = ? and firm_representante = ? or user_responsible = ? and firm_responsible = ? or user_asesor = ? and firm_asesor = ?",Current.user.id,0,Current.user.id,0,Current.user.id,0)  
        @matrix_danger_risks = MatrixDangerRisk.where("user_legal_representative = ? and firm_legal_representative = ? or user_adviser_sst = ? and firm_adviser_sst = ? or user_responsible_sst = ? and firm_responsible_sst = ?",Current.user.id,0,Current.user.id,0,Current.user.id,0)  
        @annual_work_plans = AnnualWorkPlan.where("user_legal_representative = ? and firm_legal_representative = ? or user_adviser_sst = ? and firm_adviser_sst = ? or user_responsible_sst = ? and firm_responsible_sst = ?",Current.user.id,0,Current.user.id,0,Current.user.id,0)  
        #@occupational_exams = OccupationalExam.where("user_legal_representative = ? and firm_legal_representative = ? or user_adviser_sst = ? and firm_adviser_sst = ? or user_responsible_sst = ? and firm_responsible_sst = ?",Current.user.id,0,Current.user.id,0,Current.user.id,0)  
        @audit_reports = AuditReport.where("user_representante = ? and firm_representante = ? or user_audit = ? and firm_audit = ?",Current.user.id,0,Current.user.id,0)  
        @inves_users = InvesUser.where("user_id = ? and firm = ?",Current.user.id,0)  
        @survey_profiles = SurveyProfile.where("user_elaboro = ? and firm_elaboro = ? or user_reviso = ? and firm_reviso = ? or user_aprobo = ? and firm_aprobo = ?",Current.user.id,0,Current.user.id,0,Current.user.id,0)  
        @improvement_plans = ImprovementPlan.where("user_representante = ? and firm_representante = ? or user_responsible = ? and firm_responsible = ?",Current.user.id,0,Current.user.id,0)  
        @direction_reviews = DirectionReview.where("user_representante = ?",Current.user.id)  
        @provides_protections = ProvidesProtection.where("user_colaborador = ? and firm_colaborador = ? or user_responsible = ? and firm_responsible = ?",Current.user.id,0,Current.user.id,0)  
        @lessons = Lesson.where("user_adviser_sst = ? and firm_user_adviser_sst = ? or user_vigia = ? and firm_user_vigia = ?",Current.user.id,0,Current.user.id,0)  

        @total_firmar = 0
        @total_firmar += @firmas_pendientes.count if @firmas_pendientes.present?
        @total_firmar += @actas_pendientes.count if @actas_pendientes.present?
        @total_firmar += @description_jobs.count if @description_jobs.present?
        @total_firmar += @resources.count if @resources.present? 
        @total_firmar += @matrix_conditions.count if @matrix_conditions.present?
        @total_firmar +=  @matrix_protections.count if @matrix_protections.present?
        @total_firmar +=  @matrix_legals.count if @matrix_legals.present?
        @total_firmar +=  @matrix_goals.count if @matrix_goals.present?
        @total_firmar +=  @matrix_danger_risks.count if @matrix_danger_risks.present?
        @total_firmar +=  @annual_work_plans.count if @annual_work_plans.present?
        @total_firmar +=  @audit_reports.count if @audit_reports.present?
        @total_firmar +=  @inves_users.count if @inves_users.present?
        @total_firmar +=  @survey_profiles.count if @survey_profiles.present?
        @total_firmar +=  @improvement_plans.count if @improvement_plans.present?
        @total_firmar +=  @lessons.count if @lessons.present?

        if @direction_reviews.present?
            @direction_reviews.each do |direction_review|
                @total_firmar +=  1 if direction_review.firm_representante != 1
            end    
        end    
        if @provides_protections.present?
            @provides_protections.each do |provides_protection|
                @total_firmar +=  1 
            end    
        end    
        

        return @total_firmar
    end    

    def self.firmas(evidence)
        @firms = Firm.where("evidence_id = ?", evidence)
        return @firms;
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

    def self.crear_firmas(evi)
        evidence = Evidence.find(evi)  
        template = Template.find(evidence.template_id)
        if  evidence.present? then
            user_legal_representative = User.find_by("entity = ? and legal_representative = ?", evidence.entity_id.to_i, 1) 
            user_responsible = User.find(evidence.entity.responsible_sst.to_i)  if evidence.entity.responsible_sst.present? && evidence.entity.responsible_sst.to_i > 0 
            user_asesor_externo = User.find(evidence.entity.external_consultant.to_i)  if evidence.entity.external_consultant.present? && evidence.entity.external_consultant.to_i > 0 
            user_presidente_copasst = User.find_by("entity = ? and president_copasst = ?", evidence.entity_id.to_i, 1) 
            user_secretario_copasst = User.find_by("entity = ? and secretary_copasst = ?", evidence.entity_id.to_i, 1) 
            user_vigia = User.find_by("entity = ? and vigia_sgsst = ?", evidence.entity_id.to_i, 1) 

            if template.present? && user_legal_representative.present? && template.firm_representante == 1  then
                firma_nueva  = Firm.new
                firma_nueva.user_id = user_legal_representative.id
                firma_nueva.legal_representative = 1
                firma_nueva.evidence_id = evidence.id
                firma_nueva.post = 'Representante Legal'  
                firma_nueva.save
            end   

            if template.present? && user_presidente_copasst.present? && template.firm_presidente_copasst == 1 then
                firma_nueva  = Firm.new
                firma_nueva.user_id = user_presidente_copasst.id
                firma_nueva.evidence_id = evidence.id
                firma_nueva.post = 'Presidente COPASST'  
                firma_nueva.save
            end   

            if template.present? && user_vigia.present? && template.firm_vigia == 1 then
                firma_nueva  = Firm.new
                firma_nueva.user_id = user_vigia.id
                firma_nueva.evidence_id = evidence.id
                firma_nueva.post = 'Vigía SG-SST'  
                firma_nueva.save
            end   

            if template.present? && user_secretario_copasst.present? && template.firm_secretario_copasst == 1 then
                firma_nueva  = Firm.new
                firma_nueva.user_id = user_secretario_copasst.id
                firma_nueva.evidence_id = evidence.id
                firma_nueva.post = 'Secretario(a) COPASST'  
                firma_nueva.save
            end   

            if template.present? && user_responsible.present? && template.firm_responsable == 1 then
                firma_nueva  = Firm.new
                firma_nueva.user_id = user_responsible.id
                firma_nueva.evidence_id = evidence.id
                firma_nueva.post = 'Responsable SG-SST'  
                firma_nueva.save
            end 
            
            if template.present? && user_asesor_externo.present? && template.firm_asesor == 1  then
                firma_nueva  = Firm.new
                firma_nueva.user_id = user_asesor_externo.id
                firma_nueva.evidence_id = evidence.id
                firma_nueva.post = 'Asesor Externo SG-SST'  
                firma_nueva.save
            end 
            
        end    
    end   
    
    def self.automatico_firma(participant)
        firma_nueva  = Firm.new
        firma_nueva.user_id = participant.user_id
        firma_nueva.evidence_id = participant.evidence_id
        firma_nueva.post = participant.user.cargo_rol  
        firma_nueva.save
    end    
end
