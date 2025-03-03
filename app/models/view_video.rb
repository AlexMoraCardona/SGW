class ViewVideo < ApplicationRecord
    belongs_to :user


    def self.ransackable_attributes(auth_object = nil)
        ["name_view", "presentation", "type_presentation", "date_view", "user_id"]
    end 

    def self.ransackable_associations(auth_object = nil)
        []
    end    
    
    def self.label_type(dato)
        if dato == 0 ; 'Presentacion'
        elsif  dato == 1 ; 'Multimedia'
        end 
    end         
end
