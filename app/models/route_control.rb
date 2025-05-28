class RouteControl < ApplicationRecord
    belongs_to :user

    def self.ransackable_attributes(auth_object = nil)
                ["id", "date_control", "observation", "time_initial_control", "time_final_control", "place", "vehicle_type", "user_id"]
    end 

    def self.ransackable_associations(auth_object = nil)
        []
    end 

    def self.label_tipo_vehiculo(dato)
        if dato == 0 ; 'Moto'
        elsif  dato == 1 ; 'Carro'
        end 
    end 
    
end
