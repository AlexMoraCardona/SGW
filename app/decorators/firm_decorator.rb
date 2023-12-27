class FirmDecorator < Draper::Decorator
	delegate_all
	decorates :firm

    def label_legal_representative 
        if legal_representative == 0 then
            'No'
        else
            'Si'
        end 
  	end

    def label_authorize_firm 
        if authorize_firm == 0 then
            'No'
        else
            'Si'
        end 
  	end

      

end  