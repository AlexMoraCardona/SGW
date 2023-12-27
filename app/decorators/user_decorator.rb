
class UserDecorator < Draper::Decorator
	delegate_all
	decorates :user
  
	def select_state
		[
			['Inactivo', 0],
			['Activo', 1]
		]
	end

  	def label_state
    	if select_state.flatten.include?(state.to_i)
      		select_state.each { |nombre, id| return nombre if state.to_i == id }
    	end
  	end

end  




