class MotoChecklist < ApplicationRecord
    has_many_attached :moto_files
    belongs_to :entity
    belongs_to :user

    def self.ransackable_attributes(auth_object = nil)
                ["id", "date_list", "plate_moto", "user_id", "entity_id", "user_autoriza"]
    end 

    def self.ransackable_associations(auth_object = nil)
        []
    end 

    def self.cant_eve(moto)
        @cant_eve = 0
        @cant_eve += 1 if moto.health_conditions == 1
        @cant_eve += 1 if moto.protective_equipment == 1
        @cant_eve += 1 if moto.tire_condition == 1
        @cant_eve += 1 if moto.lights_condition == 1
        @cant_eve += 1 if moto.horn_condition == 1
        @cant_eve += 1 if moto.mirrors_condition == 1
        @cant_eve += 1 if moto.liquids_condition == 1
        @cant_eve += 1 if moto.fluids_condition == 1
        @cant_eve += 1 if moto.brakes_condition == 1
        @cant_eve += 1 if moto.transmission_condition == 1
        @cant_eve += 1 if moto.documents_condition == 1
        @cant_eve += 1 if moto.kit_condition == 1
        return @cant_eve;
    end    
end
