class EconomicActivityCode < ApplicationRecord

    def self.ransackable_attributes(auth_object = nil)
        ["risk_class", "ciu_code", "additional_digits", "economic_activity_description"]
    end 

    def names_with_initial
        "#{ciu_code} - #{economic_activity_description}"
    end
   
end
