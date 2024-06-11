class Event < ApplicationRecord
    belongs_to :entity
    belongs_to :user

    def self.labelsino(dato)
        if dato == 0 ; 'NO'
        elsif dato == 1 ; 'SI'
        end 
    end 

end
