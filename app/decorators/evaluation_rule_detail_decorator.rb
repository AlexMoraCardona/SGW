class EvaluationRuleDetailDecorator < Draper::Decorator
	delegate_all
	decorates :evaluation_rule_detail

	def label_meets 
        if evaluation_rule_detail.meets == 0 ; 'No cumple'
        elsif evaluation_rule_detail.meets == 1 ; 'Si cumple'
        elsif evaluation_rule_detail.meets == 2 ; 'No aplica'
        end
    end

	def label_apply
        if evaluation_rule_detail.apply == 0 then
            'No aplica'
        else
            'Si aplica'
        end 
  	end

      def crear_firma 
        if legal_representative == 0 then
            'No'
        else
            'Si'
        end 
  	end


       
    def label_cycle
        if evaluation_items.standar_detail_item.standar_detail.standar.cycle == 1 ; 'Planear'
        elsif evaluation_items.standar_detail_item.standar_detail.standar.cycle == 2 ; 'Hacer'
        elsif evaluation_items.standar_detail_item.standar_detail.standar.cycle == 3 ; 'Verificar'
        elsif evaluation_items.standar_detail_item.standar_detail.standar.cycle == 4 ; 'Actuar'
        end 
    end
    

end  