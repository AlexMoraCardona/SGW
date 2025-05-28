class CarChecklist < ApplicationRecord
    has_many_attached :car_files
    belongs_to :entity
    belongs_to :user

    def self.ransackable_attributes(auth_object = nil)
                ["id", "date_list", "plate_car", "user_id", "entity_id", "user_autoriza"]
    end 

    def self.ransackable_associations(auth_object = nil)
        []
    end 

    def self.cant_eve(car)
        @cant_eve = 0
        @cant_eve += 1 if car.health_conditions == 1
        @cant_eve += 1 if car.tire_condition == 1
        @cant_eve += 1 if car.lights_condition == 1
        @cant_eve += 1 if car.horn_condition == 1
        @cant_eve += 1 if car.mirrors_condition == 1
        @cant_eve += 1 if car.liquids_condition == 1
        @cant_eve += 1 if car.fluids_condition == 1
        @cant_eve += 1 if car.brakes_condition == 1
        @cant_eve += 1 if car.windshield_condition == 1
        @cant_eve += 1 if car.retention_condition == 1
        @cant_eve += 1 if car.documents_condition == 1
        @cant_eve += 1 if car.prevention_condition == 1
        @cant_eve += 1 if car.witnesses_condition == 1
        @cant_eve += 1 if car.documents_condition == 1
        @cant_eve += 1 if car.documents_condition == 1
        return @cant_eve;
    end    
end
