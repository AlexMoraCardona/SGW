class Resource < ApplicationRecord
    belongs_to :entity
    has_many :resource_items

    def name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end
    
    def label_firm(firm)
        if firm == 0 ; 'NO'
        elsif  firm == 1 ; 'SI'
        end 
    end  
    
    def name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end  

    def label(dato)
        if dato == 0 ; 'NO'
        elsif  dato == 1 ; 'SI'
        end 
    end 

    def labelx(dato)
        if dato == 0 ; ' '
        elsif  dato == 1 ; 'X'
        end 
    end 


    
end
