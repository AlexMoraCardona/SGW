class Investigation < ApplicationRecord
    belongs_to :entity
    belongs_to :user
    has_rich_text :datos_complementarios
    has_many_attached :registros_fotograficos
    has_rich_text :plan_accion
    has_rich_text :actos_inseguros
    has_rich_text :condiciones_inseguras
    has_rich_text :factores_personales
    has_rich_text :factores_administrativos


    def self.label_type_event(dato)
        if dato == 0 ; 'INCIDENTE'
        elsif  dato == 1 ; 'ACCIDENTE'
        elsif  dato == 2 ; 'ACCIDENTE GRAVE'
        elsif  dato == 3 ; 'ACCIDENTE MORTAL'
        end 
    end  

    def self.label_accident_usual(dato)
        if dato == 0 ; 'SI'
        elsif  dato == 1 ; 'NO'
        end 
    end  

    
    def self.label_inform_prompt(dato)
        if dato == 0 ; 'SI'
        elsif  dato == 1 ; 'NO'
        end 
    end 
    
    
    def self.label_similar_events(dato)
        if dato == 0 ; 'SI'
        elsif  dato == 1 ; 'NO'
        end 
    end 

    




end
