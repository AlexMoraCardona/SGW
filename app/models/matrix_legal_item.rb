class MatrixLegalItem < ApplicationRecord
    belongs_to :matrix_legal
    has_one_attached :attach_evidence

    def label_apply(apply)
        if apply == 0 ; 'NO APLICA'
        elsif apply == 1 ; 'SI APLICA'
        end 
    end    

    def label_meets(meets)
        if meets == 0 ; 'NO (0%)'
        elsif meets == 1 ; 'PARCIAL (50%)'
        elsif meets == 2 ; 'SI (100%)'
        end 
    end    
    
    
    def self.crear_normas(matrix)
        matrix_legal = MatrixLegal.find(matrix) if matrix.present?
        legal_rules = LegalRule.where("clasification_norma = ? and state_norma = ?",0,0)

        if  legal_rules.present? then
            legal_rules.each do |legal_rule| 
                matrix_legal_item = MatrixLegalItem.new
                matrix_legal_item.risk_factor  = legal_rule.risk_factor
                matrix_legal_item.issuing_entity = legal_rule.issuing_entity
                matrix_legal_item.requirement = legal_rule.requirement
                matrix_legal_item.rule_name = legal_rule.rule_name
                matrix_legal_item.applicable_article = legal_rule.applicable_article
                matrix_legal_item.description_compliance = legal_rule.description_compliance
                matrix_legal_item.matrix_legal_id = matrix_legal.id
                matrix_legal_item.year = legal_rule.year
                matrix_legal_item.legal_rule_id = legal_rule.id
                matrix_legal_item.fec_norma = legal_rule.fec_norma
                matrix_legal_item.meets = 0
                matrix_legal_item.apply = 0
                matrix_legal_item.save

            end   
        end
    end


end
