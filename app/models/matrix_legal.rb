class MatrixLegal < ApplicationRecord
    belongs_to :entity
    has_many :matrix_legal_items

    def name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end


    def label_apply(apply)
        if apply == 0 ; 'NO APLICA'
        elsif apply == 1 ; 'SI APLICA'
        end 
    end  
    
    def label_firm(firm)
        if firm == 0 ; 'NO'
        elsif  firm == 1 ; 'SI'
        end 
    end    

    def label_meets(meets)
        if meets == 0 ; 'NO (0%)'
        elsif meets == 1 ; 'PARCIAL (50%)'
        elsif meets == 2 ; 'SI (100%)'
        end 
    end        

    def self.new_history(matrix_legal, matrix_legal_items)
        @history_matrix_legal = HistoryMatrixLegal.new
        @history_matrix_legal.date_create = matrix_legal.date_create 
        @history_matrix_legal.user_legal_representative = matrix_legal.user_legal_representative
        @history_matrix_legal.user_adviser_sst = matrix_legal.user_adviser_sst
        @history_matrix_legal.user_responsible_sst = matrix_legal.user_responsible_sst
        @history_matrix_legal.entity_id = matrix_legal.entity_id
        @history_matrix_legal.matrix_legal_id = matrix_legal.id
        matrix_legal_items.each do |item|
            @history_matrix_legal.meets_earring  += 1 if item.meets == 0
            @history_matrix_legal.meets_partial  += 1 if item.meets == 1
            @history_matrix_legal.meets_compliment += 1 if item.meets == 2
        end    
        
        @history_matrix_legal.save 
            
        matrix_legal_items.each do |item|        
            @history_item  = HistoryMatrixLegalItem.new 
            @history_item.consecutive  = item.consecutive
            @history_item.risk_factor = item.risk_factor
            @history_item.issuing_entity = item.issuing_entity
            @history_item.requirement = item.requirement
            @history_item.rule_name = item.rule_name
            @history_item.applicable_article = item.applicable_article
            @history_item.apply = item.apply
            @history_item.evidence_compliance = item.evidence_compliance
            @history_item.meets = item.meets
            @history_item.description_compliance = item.description_compliance
            @history_item.history_matrix_legal_id = @history_matrix_legal.id
            @history_item.save
        end    
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
end
