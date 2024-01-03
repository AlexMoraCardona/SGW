class Calendar < ApplicationRecord
    belongs_to :adm_calendar
    has_many :activities

    def self.crear_citar(n, id, vector)
        i = 0
        while i < n
            @activity_user = ActivityUser.new
            @activity_user.activity_id = id.to_i
            @activity_user.user_id = vector[i].to_i
            @activity_user.mandatory  = 1
            @activity_user.save
            i = i + 1
        end        
    end

    def diasem(calendar)
        if calendar.name_day == "lunes" ; return 1;
        elsif  calendar.name_day == "martes" ; return 2;
        elsif  calendar.name_day == "miércoles" ; return 3;
        elsif  calendar.name_day == "jueves" ; return 4;
        elsif  calendar.name_day == "viernes" ; return 5;
        elsif  calendar.name_day == "sábado" ; return 6;
        elsif  calendar.name_day == "domingo" ; return 7;
        end 
    end     

    def hoy(calendar)
        if calendar.year == Date.today.year && calendar.month == Date.today.month && calendar.day == Date.today.day
            return 1;
        else    
            return 0;
        end    
    end


    def event(calendar)
        @activities = Activity.where("calendar_id = ?", calendar.id)
        if @activities.present?
            return 1;
        else    
            return 0;
        end    
    end

    def self.label_month(month)
        if month == 1 ; 'enero'
        elsif  month == 2 ; 'febrero'
        elsif  month == 3 ; 'marzo'
        elsif  month == 4 ; 'abril'
        elsif  month == 5 ; 'mayo'
        elsif  month == 6 ; 'junio'
        elsif  month == 7 ; 'julio'
        elsif  month == 8 ; 'agosto'
        elsif  month == 9 ; 'septiembre'
        elsif  month == 10 ; 'octubre'
        elsif  month == 11 ; 'noviembre'
        elsif  month == 12 ; 'diciembre'
        end 
    end 

    def self.crear(adm_calendar)
        y = adm_calendar.year
        dia = adm_calendar.day_initial
        m = 1
        while m < 13
            if m == 1 || m == 3 || m == 5 || m == 7 || m == 8 || m == 10 || m == 12
                d = 1
                while d < 32
                    @calendar = Calendar.new
                    @calendar.day = d
                    @calendar.month = m
                    @calendar.year = y 
                    @calendar.adm_calendar_id = adm_calendar.id
                    @calendar.festive = 1 if dia == 7
                    if dia == 1; @calendar.name_day = 'lunes'
                    elsif dia == 2; @calendar.name_day = 'martes'
                    elsif dia == 3; @calendar.name_day = 'miércoles'
                    elsif dia == 4; @calendar.name_day = 'jueves'
                    elsif dia == 5; @calendar.name_day = 'viernes'
                    elsif dia == 6; @calendar.name_day = 'sábado'
                    elsif dia == 7; @calendar.name_day = 'domingo'
                    end
                    @calendar.save
                    if dia < 7
                        dia += 1
                    else
                         dia = 1 
                    end     
                    d = d + 1  
                end    
            elsif m == 4 || m == 6 || m == 9 || m == 11 
                d = 1
                while d < 31
                    @calendar = Calendar.new
                    @calendar.day = d
                    @calendar.month = m
                    @calendar.year = y 
                    @calendar.adm_calendar_id = adm_calendar.id
                    @calendar.festive = 1 if dia == 7
                    if dia == 1; @calendar.name_day = 'lunes'
                    elsif dia == 2; @calendar.name_day = 'martes'
                    elsif dia == 3; @calendar.name_day = 'miércoles'
                    elsif dia == 4; @calendar.name_day = 'jueves'
                    elsif dia == 5; @calendar.name_day = 'viernes'
                    elsif dia == 6; @calendar.name_day = 'sábado'
                    elsif dia == 7; @calendar.name_day = 'domingo'
                    end
                    @calendar.save
                    if dia < 7
                        dia += 1
                    else
                         dia = 1 
                    end     
                    d = d + 1  
                end    

            elsif m == 2    
                d = 1
                if adm_calendar.bisiesto == 0
                    feb = 29
                else
                    feb = 30
                end

                while d < feb
                    @calendar = Calendar.new
                    @calendar.day = d
                    @calendar.month = m
                    @calendar.year = y 
                    @calendar.adm_calendar_id = adm_calendar.id
                    @calendar.festive = 1 if dia == 7
                    if dia == 1; @calendar.name_day = 'lunes'
                    elsif dia == 2; @calendar.name_day = 'martes'
                    elsif dia == 3; @calendar.name_day = 'miércoles'
                    elsif dia == 4; @calendar.name_day = 'jueves'
                    elsif dia == 5; @calendar.name_day = 'viernes'
                    elsif dia == 6; @calendar.name_day = 'sábado'
                    elsif dia == 7; @calendar.name_day = 'domingo'
                    end
                    @calendar.save
                    if dia < 7
                        dia += 1
                    else
                         dia = 1 
                    end     
                    d = d + 1  
                end    
                
            end    

            m = m + 1
        end
    end    
end
