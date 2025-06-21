class AnnualWorkPlan < ApplicationRecord
    belongs_to :entity
    has_many :annual_work_plan_items

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

    def self.buscar_plan_trabajo_anual(entity)
        annual_work_plans  =  AnnualWorkPlan.where("entity_id = ?",entity) if entity.present?
        return  annual_work_plans   
    end
  
end
