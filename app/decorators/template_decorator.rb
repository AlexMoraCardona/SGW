class TemplateDecorator < Draper::Decorator
	delegate_all
	decorates :template
  

  	def label_state
        if state == 0 then
            'Inactivo'
        else 
            'Activo'
        end 
  	end
end  