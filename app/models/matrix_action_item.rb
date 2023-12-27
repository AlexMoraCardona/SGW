class MatrixActionItem < ApplicationRecord
    belongs_to :matrix_corrective_action

    def label_state_actions(state)
        if state == 0 ; 'Abierto'
        elsif state == 1 ; 'En proceso'
        elsif state == 2 ; 'Cerrado'
        end 
    end      

    def label_si_no(dato)
        if dato == 0 ; 'No'
        elsif dato == 1 ; 'Si'
        end 
    end 
    
    def label_origin_action(origin)
        if origin == 0 ; 'Accidentes o Incidentes'
        elsif origin == 1 ; 'Auditoría En proceso'
        elsif origin == 2 ; 'Inspecciones'
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
