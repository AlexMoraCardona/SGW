class FormatAction < ApplicationRecord
    belongs_to :entity

    def self.name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end 

    def self.label_action_completed(dato)
        if dato == 0 ; 'NO'
        elsif dato == 1 ; 'SI'
        end 
    end    
end
