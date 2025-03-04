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
 
    def self.label_apply(dato)
      if dato == 0 ; 'NO'
      elsif dato == 1 ; 'SI'
      end 
    end
    
    def self.label_meets(dato)
      if dato == 0 ; 'NO'
      elsif dato == 1 ; 'SI'
      end 
    end     

    
end
