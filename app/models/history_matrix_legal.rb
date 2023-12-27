class HistoryMatrixLegal < ApplicationRecord
    belongs_to :entity
    has_many :history_matrix_legal_items

    def name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end
end
