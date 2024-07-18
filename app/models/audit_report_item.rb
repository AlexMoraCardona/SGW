class AuditReportItem < ApplicationRecord
    has_many_attached :finding_evidences

    
    def self.label_type_finding(dato)
        if dato == 0 ; 'Conformidad'
        elsif  dato == 1 ; 'No conformidad'
        elsif  dato == 2 ; 'Observación'
        end 
    end     

    def self.label_type_action(dato)
        if dato == 0 ; 'Preventiva'
        elsif  dato == 1 ; 'Correctiva'
        elsif  dato == 2 ; 'Mejora'
        end 
    end     


end
