class AdmCalendar < ApplicationRecord
    has_many :calendars

    def label_si_no(dato)
        if dato == 0 ; 'No'
        elsif dato == 1 ; 'Si'
        end 
    end 

    def label_day_initial(day)
        if day == 1 ; 'lunes'
        elsif day == 2 ; 'martes'
        elsif day == 3 ; 'miércoles'
        elsif day == 4 ; 'jueves'
        elsif day == 5 ; 'viernes'
        elsif day == 6 ; 'sabado'
        elsif day == 7 ; 'domingo'
        end 
    end      

end
