class Participant < ApplicationRecord
    belongs_to :user
    belongs_to :evidence

    def self.nombre(dato)
        @nombre = User.find(dato.to_i).name
        return  @nombre 
    end

    def self.documento(dato)
        @documento = User.find(dato.to_i).nro_document

        cadena = @documento.to_s
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

    def self.crear_participantes(evi)
        evidence = Evidence.find(evi)  
        template = Template.find(evidence.template_id)

        if  evidence.present? then
            entidad = Entity.find(evidence.entity_id) if evidence.present? 
            user_responsible = User.find(entidad.responsible_sst.to_i) if entidad.present? && entidad.responsible_sst.to_i > 0 
            user_representante_legal = User.find_by("entity = ? and legal_representative = ?", evidence.entity_id.to_i, 1) 
            user_asesor_externo = User.find(entidad.external_consultant.to_i) if entidad.present? && entidad.external_consultant.to_i > 0 
            user_vigia = User.find_by("entity = ? and vigia_sgsst = ?", evidence.entity_id.to_i, 1) 



            if template.present? && user_vigia.present? && template.participant_vigia == 1  then
                participante_nuevo  = Participant.new
                participante_nuevo.user_id = user_vigia.id
                participante_nuevo.evidence_id = evidence.id
                participante_nuevo.post_copasst = 'Vigía SG-SST'  
                participante_nuevo.vigia = 1
                participante_nuevo.save
            end   

            if template.present? && user_responsible.present? && template.participant_responsable == 1  then
                participante_nuevo  = Participant.new
                participante_nuevo.user_id = user_responsible.id
                participante_nuevo.evidence_id = evidence.id
                participante_nuevo.post_copasst = 'Responsable SG-SST'  
                participante_nuevo.collaborator = 1
                participante_nuevo.responsible_ssst = 1
                participante_nuevo.save
            end 

            if template.present? && user_asesor_externo.present? && template.participant_asesor == 1  then
                participante_nuevo  = Participant.new
                participante_nuevo.user_id = user_asesor_externo.id
                participante_nuevo.evidence_id = evidence.id
                participante_nuevo.post_copasst = 'Asesor Externo SG-SST'  
                participante_nuevo.external_consultant = 1
                participante_nuevo.save
            end   

            
            if template.present? && user_representante_legal.present? && template.participant_representante == 1  then
                participante_nuevo  = Participant.new
                participante_nuevo.user_id = user_representante_legal.id
                participante_nuevo.evidence_id = evidence.id
                participante_nuevo.post_copasst = 'Representante Legal'  
                participante_nuevo.collaborator = 1
                participante_nuevo.save
            end   
            
        end    
    end    


end
