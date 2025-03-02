class Training < ApplicationRecord
    belongs_to :entity
    has_many :training_items

    def name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end
    
    def label_firm(firm)
        if firm == 0 ; 'NO'
        elsif  firm == 1 ; 'SI'
        end 
    end  
    
    def name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end   

    def self.capacitaciones(entity)
        año = Time.new.year 
        training_items = nil
        training = Training.find_by(year: año, entity_id: entity.id) if entity.present?
        training_items = TrainingItem.where("training_id = ?",training.id) if training.present?
        total = training_items.count if training_items.present?

        @datos_capacitacion = []
        if training_items.present?
            training_items.group_by(&:state_cap).each  do |niv, det|
                cant = 0
                det.each do |d|
                   cant += 1 
                end  
                por = ((cant.to_f / total.to_f) * 100).round(2).to_f if total.to_f > 0

                pendientes = "Pendientes: " +  cant.to_s  if  niv.to_i == 0
                realizadas = "Realizadas: " + cant.to_s if  niv.to_i == 1
                canceladas = "Canceladas: " + cant.to_s if  niv.to_i == 2

                @datos_capacitacion.push([pendientes, por.to_f]) if  niv.to_i == 0
                @datos_capacitacion.push([realizadas, por.to_f]) if  niv.to_i == 1
                @datos_capacitacion.push([canceladas, por.to_f]) if  niv.to_i == 2
            end
        end
        return   @datos_capacitacion  
    end     

end
