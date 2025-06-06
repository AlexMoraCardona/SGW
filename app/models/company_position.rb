class CompanyPosition < ApplicationRecord
    belongs_to :entity


    def self.name_cargo(dato)
        name = 'No encontrado'
        name = CompanyPosition.find_by(id: dato).name if dato.to_i > 1
        return name 
    end

    def self.listar_cargo(entity)
        cargos = CompanyPosition.where("entity_id = ? or id = ?",entity,1)
        return cargos 
    end


end
