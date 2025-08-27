class LegalRule < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
                ["risk_factor", "requirement", "rule_name", "fecha_norma", "issuing_entity", "applicable_article", "description_compliance", "state_norma", "clasification_norma", "fec_norma", "year"]
    end 

    def self.ransackable_associations(auth_object = nil)
        []
    end 


    def self.label_clasification_norma(dato)
        if dato == 0 ; 'Genérica'
        elsif dato == 1 ; 'Específica'
        end 
    end   

    def self.label_state_norma(dato)
        if dato == 0 ; 'Activa'
        elsif dato == 1 ; 'Inactiva'
        end 
    end   


end
