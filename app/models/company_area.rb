class CompanyArea < ApplicationRecord
    belongs_to :entity
    has_many :surveillance_inspections, dependent: :restrict_with_error

    def self.name_area(dato)
        name = 'No encontrado'
        name = CompanyArea.find_by(id: dato).name if dato.to_i > 0
        return name 
    end

end
