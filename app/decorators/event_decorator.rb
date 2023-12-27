class EventDecorator < Draper::Decorator
	delegate_all
	decorates :event
  

  	def label_work_accident
        if work_accident == 0 then
            'No'
        else 
            'Si'
        end 
  	end

  	def label_mortal_accident
        if mortal_accident == 0 then
            'No'
        else 
            'Si'
        end 
  	end
      
  	def label_occupational_disease
        if occupational_disease == 0 then
            'No'
        else 
            'Si'
        end 
  	end
      
  	def label_laboral_inhability
        if laboral_inhability == 0 then
            'No'
        else 
            'Si'
        end 
  	end

    def label_common_inhability
        if common_inhability == 0 then
            'No'
        else 
            'Si'
        end 
  	end
 
end  