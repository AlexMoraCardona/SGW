class ActivityUser < ApplicationRecord
    belongs_to :activity
    belongs_to :user

    def label_si_no(dato)
        if dato == 0 ; 'No'
        elsif dato == 1 ; 'Si'
        end 
    end 
end