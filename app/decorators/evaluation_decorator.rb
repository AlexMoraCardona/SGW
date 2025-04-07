class EvaluationDecorator < Draper::Decorator
	delegate_all
	decorates :evaluation

    def label_cycle 
        if evaluation_items.standar_detail_item.standar_detail.standar.cycle == 1 ; 'Planear'
        elsif evaluation_items.standar_detail_item.standar_detail.standar.cycle == 2 ; 'Hacer'
        elsif evaluation_items.standar_detail_item.standar_detail.standar.cycle == 3 ; 'Verificar'
        elsif evaluation_items.standar_detail_item.standar_detail.standar.cycle == 4 ; 'Actuar'
        end 
    end

end  
