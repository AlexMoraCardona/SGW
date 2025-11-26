class MatrixActionItem < ApplicationRecord
    belongs_to :matrix_corrective_action
    has_many_attached :matrix_action_item_files 

    def label_state_actions(state)
        if state == 0 ; 'Abierto'
        elsif state == 1 ; 'Cerrado'
        end 
    end      

    def label_si_no(dato)
        if dato == 0 ; 'No'
        elsif dato == 1 ; 'Si'
        end 
    end 
    
    def label_origin_action(origin)
        if origin == 0 ; 'Revisión por la dirección'
        elsif origin == 1 ; 'Inspecciones'
        elsif origin == 2 ; 'Indicadores'
        elsif origin == 3 ; 'Recomendaciones COPASST'
        elsif origin == 4 ; 'Auditorías'
        elsif origin == 5 ; 'Investigaciones AT-EL'
        elsif origin == 6 ; 'Evaluación inicial'
        elsif origin == 7 ; 'Cumplimiento requisitos legales'
        elsif origin == 8 ; 'Intervención de peligros y riesgos priorizados'
        elsif origin == 9 ; 'Quejas o sugerencias'
        elsif origin == 10 ; 'Reporte de actos y condiciones inseguras'
        elsif origin == 11 ; 'Cambios de procedimientos'
        elsif origin == 12 ; 'Simulacros emergencias'
        elsif origin == 13 ; 'Recomendaciones ARL'
        elsif origin == 13 ; 'Otros'
        end 
    end 
    

    def label_action_implement(action)
        if action == 0 ; 'Inmediata'
        elsif action == 1 ; 'Corto Plazo'
        elsif action == 2 ; 'Mediano Plazo'
        elsif action == 3 ; 'Largo Plazo'
        end 
    end  

    

end
