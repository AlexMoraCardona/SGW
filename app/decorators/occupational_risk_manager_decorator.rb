class OccupationalRiskManagerDecorator < Draper::Decorator
	delegate_all
	decorates :occupational_risk_manager
  

  	def label_condition
        if condition  then
            'Activo'
        else 
            'Inactivo'
        end 
  	end

end  