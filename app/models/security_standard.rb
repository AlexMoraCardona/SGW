class SecurityStandard < ApplicationRecord
    belongs_to :entity
    has_rich_text :standard_security

    def self.label_user(user_id)
        name = 'No encontrado'
        if user_id > 0
            user =  User.find(user_id)
            name = user.name
        end    
        return  name 
    end 

    def self.label_area(area_id)
        name = 'No encontrado'
        if area_id > 0
            area =  CompanyArea.find(area_id)
            name =  area.name
        end    
        return  name 
    end 

    def self.label_tipo(dato)
        name = 'No encontrado'
        if dato == 0 then name = 'PREVENTIVA'
        elsif  dato == 1 then name =  'CORRECTIVA'
        elsif  dato == 2 then name =  'MEJORA'
        end 
        return  name 
    end 

end
