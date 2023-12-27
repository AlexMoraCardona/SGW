class Activity < ApplicationRecord
    belongs_to :calendar
    belongs_to :entity
    belongs_to :user
    has_many :activity_users


    def label_si_no(dato)
        if dato == 0 ; 'No'
        elsif dato == 1 ; 'Si'
        end 
    end     

    def label_state(dato)
        if dato == 0 ; 'Pendiente'
        elsif dato == 1 ; 'Cumplida'
        elsif dato == 2 ; 'Cancelada'
        end 
    end     

end

