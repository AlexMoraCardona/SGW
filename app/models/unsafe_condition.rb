class UnsafeCondition < ApplicationRecord
    belongs_to :entity

    def name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end  

end
