class Simulacrum < ApplicationRecord
    belongs_to :entity
    has_rich_text :preparation
    has_rich_text :conclusions
    has_rich_text :recommendations
    has_many_attached :simulacro_files  


    def self.label_user(user_id)
        name = 'No encontrado'
        if user_id > 0
            user =  User.find(user_id)
            name = user.name
        end    
        return  name 
    end 

end
