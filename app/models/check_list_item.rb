class CheckListItem < ApplicationRecord
    belongs_to :check_list
    
    def self.label_state(dato)
        if dato == 0 ; 'Activo'
        elsif  dato == 1 ; 'Inactivo'
        end 
    end 

    def self.label_clasification(dato)
        clasificacion = 'No encontrada'
        if dato == 0 ; clasificacion = 'Condiciones generales del área'
        elsif  dato == 1 ; clasificacion = 'Control de sustancias químicas'
        elsif  dato == 2 ; clasificacion = 'Uso de EPP'
        elsif  dato == 3 ; clasificacion = 'Control de riesgos térmicos'
        elsif  dato == 4 ; clasificacion = 'Control de aplicación de químicos y pintura'
        elsif  dato == 5 ; clasificacion = 'Control de radiación UV'
        elsif  dato == 6 ; clasificacion = 'Control de herramientas y riesgo mecánico'
        elsif  dato == 7 ; clasificacion = 'Control de procesos de inmesión y grabado'
        elsif  dato == 8 ; clasificacion = 'Condiciones del trabajador'
        end 
        return clasificacion;
    end 

end
