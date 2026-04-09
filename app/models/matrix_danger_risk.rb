class MatrixDangerRisk < ApplicationRecord
    belongs_to :entity
    has_many :matrix_danger_items
    
    def self.name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id) if user_id.present?
        name = user.name if user.present?
        return  name 
    end

    def self.resumen(items)
        @total_items = 0
        @no = 0
        @parcial = 0
        @si = 0
        items.each do |item| 
            @total_items += 1 
            if item.meets.to_i == 0 ; @no += 1
            elsif item.meets.to_i == 1 ; @parcial += 1
            elsif item.meets.to_i == 2 ; @si += 1
            end
        end 
        return @total_items
    end     

    def self.label_firm(firm)
        if firm == 0 ; 'NO'
        elsif  firm == 1 ; 'SI'
        end 
    end  

    def self.total_peligros_riesgos(entity)
        matrix_danger_items = nil
        matrix_danger_risks = MatrixDangerRisk.where("entity_id = ?",entity).last if entity.present?
        matrix_danger_items = MatrixDangerItem.where('matrix_danger_risk_id = ?', matrix_danger_risks.id) if matrix_danger_risks.present?
        totalpeligros = 0

        if matrix_danger_items.present? then 
            matrix_danger_items.each do |rep| 
                totalpeligros += 1
            end
        end
        return  totalpeligros   
    end

    def self.inter_peligros_riesgos(entity)
        matrix_danger_items = nil
        matrix_danger_risks = MatrixDangerRisk.where("entity_id = ?",entity).last if entity.present?
        matrix_danger_items = MatrixDangerItem.where('matrix_danger_risk_id = ?', matrix_danger_risks.id) if matrix_danger_risks.present?

        totalpeligrosinter = 0

        if matrix_danger_items.present? then 
            matrix_danger_items.each do |rep| 
                if rep.danger_intervened == 1 then
                    totalpeligrosinter += 1
                end    
            end
        end    
        return totalpeligrosinter
    end


    def self.buscar_matrix_danger_risk(entity)
        matrix_danger_risk = MatrixDangerRisk.where("entity_id = ?",entity).last  if entity.present?
        return  matrix_danger_risk   
    end

    def self.duplicar_mpr(matrix)
        matrix_danger_risk = MatrixDangerRisk.find(matrix) if matrix.present?
        if matrix_danger_risk.present?
           duplicado = MatrixDangerRisk.new
           duplicado.version = matrix_danger_risk.version
           duplicado.code = matrix_danger_risk.code
           duplicado.entity_id = matrix_danger_risk.entity_id 
           duplicado.date_create = matrix_danger_risk.date_create
           duplicado.save
           items = MatrixDangerItem.where("matrix_danger_risk_id = ?",matrix_danger_risk.id)
            if items.present? then 
                items.each do |item| 
                    item_nuevo = MatrixDangerItem.new
                    item_nuevo.matrix_danger_risk_id = duplicado.id 
                    item_nuevo.consecutive = item.consecutive 
                    item_nuevo.year = Date.today.year  
                    item_nuevo.source_information =  item.source_information  
                    item_nuevo.activity = item.activity 
                    item_nuevo.task = item.task
                    item_nuevo.type_task = item.type_task
                    item_nuevo.origin = item.origin
                    item_nuevo.possible_effects_health = item.possible_effects_health
                    item_nuevo.possible_effects_security = item.possible_effects_security
                    item_nuevo.description_existing_control_origin = item.description_existing_control_origin
                    item_nuevo.description_existing_control_medium = item.description_existing_control_medium 
                    item_nuevo.description_existing_control_person = item.description_existing_control_person
                    item_nuevo.description_existing_control_observations = item.description_existing_control_observations 
                    item_nuevo.deficiency_level = item.deficiency_level
                    item_nuevo.exposure_level = item.exposure_level 
                    item_nuevo.probability_level = item.probability_level 
                    item_nuevo.interpretation = item.interpretation 
                    item_nuevo.consequence_level = item.consequence_level 
                    item_nuevo.level_risk_intervention = item.level_risk_intervention 
                    item_nuevo.risk_level_interpretation = item.risk_level_interpretation 
                    item_nuevo.risk_acceptability = item.risk_acceptability 
                    item_nuevo.number_exposed = item.number_exposed 
                    item_nuevo.hours_exposure = item.hours_exposure 
                    item_nuevo.worst_consequence = item.worst_consequence  
                    item_nuevo.existence_legal_requirement = item.existence_legal_requirement 
                    item_nuevo.intervention_measures_elimination = item.intervention_measures_elimination 
                    item_nuevo.intervention_measures_replacement = item.intervention_measures_replacement 
                    item_nuevo.intervention_measures_engineering_control = item.intervention_measures_engineering_control 
                    item_nuevo.intervention_measures_acsw = item.intervention_measures_acsw 
                    item_nuevo.intervention_measures_ppee = item.intervention_measures_ppee 
                    item_nuevo.responsible_implementation = item.responsible_implementation 
                    item_nuevo.type_register = item.type_register  
                    item_nuevo.proposed_date = item.proposed_date 
                    item_nuevo.implementation_date = item.implementation_date 
                    item_nuevo.follow_date = item.follow_date 
                    item_nuevo.observations =  item.observations
                    item_nuevo.clasification_danger_id = item.clasification_danger_id 
                    item_nuevo.clasification_danger_detail_id =  item.clasification_danger_detail_id
                    item_nuevo.location_id = item.location_id 
                    item_nuevo.number_exposed_contrators = item.number_exposed_contrators  
                    item_nuevo.number_exposed_totals = item.number_exposed_totals 
                    item_nuevo.danger_intervened = item.danger_intervened
                    item_nuevo.type_cargo = item.type_cargo

                    item_nuevo.save

                end
            end           
        end    
        return  matrix_danger_risk   
    end

    


end
