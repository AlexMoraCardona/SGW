class WorkingConditionItem < ApplicationRecord
    belongs_to :working_condition
    belongs_to :clasification_danger
    belongs_to :clasification_danger_detail
end
