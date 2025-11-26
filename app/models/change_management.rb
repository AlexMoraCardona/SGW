class ChangeManagement < ApplicationRecord
    belongs_to :entity
    has_many :change_management_items
    has_rich_text :description_change
    has_rich_text :analisys_change
    has_rich_text :recomendations_change


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

end
