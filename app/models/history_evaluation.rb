class HistoryEvaluation < ApplicationRecord
    belongs_to :entity
    belongs_to :evaluation
    belongs_to :risk_level
    belongs_to :rule
    has_many :history_items

    def name(id_firma)
      name = ''
      name = User.where(id: id_firma).name
      return name 
    end


    
end
