class DescriptionJob < ApplicationRecord
    belongs_to :entity
    has_rich_text :required_knowledge
    has_rich_text :competencies
    has_rich_text :job_functions
    has_rich_text :roles_responsibilities
    has_rich_text :type_evaluation
    has_rich_text :enfasis


    def label_state_job(dato)
        if dato == 0 ; 'NO VIGENTE'
        elsif  dato == 1 ; 'VIGENTE'
        elsif  dato.nil?; 'NO VIGENTE'
        end 
    end 
    
    def self.name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end
   
    def label_firma(dato)
        if dato == 0 ; 'PENDIENTE'
        elsif  dato == 1 ; 'FIRMADO'
        end 
    end    

    def self.label_area(area_id)
        name = 'No encontrado'
        if area_id > 0
            area =  CompanyArea.find(area_id)
            name =  area.name
        end    
        return  name 
    end 

end
