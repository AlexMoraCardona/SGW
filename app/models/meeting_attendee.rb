class MeetingAttendee < ApplicationRecord
    belongs_to :meeting_minute
    belongs_to :user



    def self.copiar_asistentes(dato, nuevo)
        asistentes = MeetingAttendee.where("meeting_minute_id = ?",dato)

        if asistentes.present?
            asistentes.each do |asistente|
                nuevo_asistente = MeetingAttendee.new
                nuevo_asistente.name = asistente.name 
                nuevo_asistente.post = asistente.post 
                nuevo_asistente.process_area = asistente.process_area
                nuevo_asistente.meeting_minute_id = nuevo.to_i
                nuevo_asistente.user_id = asistente.user_id
                nuevo_asistente.save
            end    
        end    
    end    

end
