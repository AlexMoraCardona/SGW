class StandarDetailItemDecorator < Draper::Decorator
	delegate_all
	decorates :standar_detail_item
  

  	def label_aplica
        if aplica == 0 then
            'No Aplica'
        else 
            'Si Aplica'
        end 
  	end

end  