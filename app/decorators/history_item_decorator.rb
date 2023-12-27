class HistoryItemDecorator < Draper::Decorator
	delegate_all
	decorates :history_item

	def label_meets
        if history_item.meets == 0 then
            'No cumple'
        elsif history_item.meets == 1 then
            'No cumple'
    	else
				'No Aplica'
        end	
  	end 
  
	def label_cycle(cycle)
		if cycle == 1 ; 'Planificar'
		elsif cycle == 2 ; 'Hacer'
		elsif cycle == 3 ; 'Verificar'
		elsif cycle == 4 ; 'Actuar'
		end 
	end
  
end  