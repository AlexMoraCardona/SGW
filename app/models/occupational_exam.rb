class OccupationalExam < ApplicationRecord
    belongs_to :entity
    has_many :occupational_exam_items

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

    def self.buscar_examenes_ocupacionales(entity)
        examenes_ocupacionales  =  OccupationalExam.where("entity_id = ?",entity) if entity.present?
        return  examenes_ocupacionales   
    end

    
end
