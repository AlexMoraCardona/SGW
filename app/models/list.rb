class List < ApplicationRecord
    belongs_to :check_list
    belongs_to :check_list_item
    belongs_to :entity

    
    def self.label_entity(dato)
        nombre = 'No encontrado'
        entity = Entity.find(dato)
        nombre = entity.business_name if entity.present?
        return nombre;
    end     

    def self.label_name(dato)
        nombre = 'No encontrado'
        check_list = CheckList.find(dato)
        nombre = check_list.name if check_list.present?
        return nombre;
    end     

end
