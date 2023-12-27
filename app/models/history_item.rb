class HistoryItem < ApplicationRecord
    belongs_to :history_evaluation
    belongs_to  :evaluation_rule_detail
end
