class AdministrativePoliticalDivision < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
        ["department_code", "department_name", "municipality_code", "municipality_name", "town_center_name", "town_center_code", "classification"]
    end 

    def name_with_initial 
        "#{town_center_name} - #{municipality_name} - #{department_name}"
    end
    
    def name_with_initial_corto 
        "#{town_center_name}"
    end
end
