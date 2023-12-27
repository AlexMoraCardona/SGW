class MatrixCorrectiveAction < ApplicationRecord
    belongs_to :entity
    has_many :matrix_action_items

    def name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end

    def label_firm(firm)
        if firm == 0 ; 'NO'
        elsif  firm == 1 ; 'SI'
        end 
    end  
end
