class HealthPromoter < ApplicationRecord
    def self.name_eps(dato)
        name = 'No encontrado'
        name = HealthPromoter.find_by(id: dato).name_entity if dato.to_i > 0
        return name 
    end
end
