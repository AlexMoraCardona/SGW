class FormPrevention < ApplicationRecord
    belongs_to :admin_extent_danger
    belongs_to :clasification_danger_detail
    belongs_to :clasification_danger

    def self.label_exposed(dato)
        if dato == 0 ; 'No expuesto'
        elsif dato == 1 ; 'Expuesto'
        end 
    end   
end
