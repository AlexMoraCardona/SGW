class Assistant < ApplicationRecord
    belongs_to :meeting_minute
    belongs_to :user

    validates :name, presence: true 


    def self.copiar_firmas(dato, nuevo)
        firmas =  Assistant.where("meeting_minute_id = ?",dato)

        if firmas.present?
            firmas.each do |firma|
                nueva_firma =  Assistant.new
                nueva_firma.name = firma.name
                nueva_firma.post =  firma.post
                nueva_firma.meeting_minute_id = nuevo.to_i
                nueva_firma.user_id = firma.user_id
                nueva_firma.save
            end    
        end    
    end    


end
