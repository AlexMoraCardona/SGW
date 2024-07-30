class EmergencyPlan < ApplicationRecord
    belongs_to :entity
    has_many_attached :plan_files
    has_rich_text :mapa_sede

    def self.name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end

    def self.label_firm(firm)
        if firm == 0 ; 'NO'
        elsif  firm == 1 ; 'SI'
        end 
    end 
    
    def self.label_sector_influencia(dato)
        if  dato == 0 ; 'Comercial'
        elsif  dato == 1 ; 'Industrial'
        elsif  dato == 2 ; 'Bancaria'
        elsif  dato == 3 ; 'Residencial'
        elsif  dato == 4 ; 'Entidades públicas'
        elsif  dato == 5 ; 'Militar y/o policial'
        end 
    end  

end
