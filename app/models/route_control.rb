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

    def self.label_entidad(dato)
        if dato == 0
           name = 'No encontrado' 
        else
            if dato.present?
                name = Entity.find_by(id: dato.to_i).business_name 
            else
                name = 'No encontrado'
            end    
        end    
        return name;
    end 

    def self.label_user(dato)
        if dato == 0
           name = 'No encontrado' 
        else
            if dato.present?
                name = User.find_by(id: dato.to_i).name 
            else
                name = 'No encontrado'
            end    
        end    
        return name;
    end 
    


end
