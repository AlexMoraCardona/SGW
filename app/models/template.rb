class Template < ApplicationRecord
    has_one_attached :file
    belongs_to :standar_detail_item

    def label_state(dato)
        if dato == 0 ; 'INACTIVO'
        elsif  dato == 1 ; 'ACTIVO'
        end 
    end  

    def self.ransackable_attributes(auth_object = nil)
                ["id", "name", "reference", "description", "standar_detail_item_id", "file", "date", "version", "state", "date_updated", "format_number", "filing"]
    end 

    def self.ransackable_associations(auth_object = nil)
        []
    end 

end
