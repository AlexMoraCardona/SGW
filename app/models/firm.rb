class Firm < ApplicationRecord
    belongs_to :user
    belongs_to :evidence

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
