class CompanyArea < ApplicationRecord
    belongs_to :entity


    def self.name_area(dato)
        name = 'No encontrado'
        name = CompanyArea.find_by(id: dato).name if dato.to_i > 1
        return name 
    end

end
