class MeetingCommitment < ApplicationRecord
    belongs_to :meeting_minute
    belongs_to :user


    def self.copiar_compromisos(dato, nuevo)
        compromisos = MeetingCommitment.where("meeting_minute_id = ?",dato)

        if compromisos.present?
            compromisos.each do |compromiso|
                nuevo_compromiso = MeetingCommitment.new
                nuevo_compromiso.number  = compromiso.number
                nuevo_compromiso.commitment = compromiso.commitment 
                nuevo_compromiso.responsible = compromiso.responsible
                nuevo_compromiso.meeting_minute_id = nuevo.to_i
                nuevo_compromiso.date_commitment = compromiso.date_commitment 
                nuevo_compromiso.state_commitment = compromiso.state_commitment 
                nuevo_compromiso.user_id = compromiso.user_id
                nuevo_compromiso.save
            end    
        end    
    end    



end
