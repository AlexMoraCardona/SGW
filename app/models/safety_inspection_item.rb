class SafetyInspectionItem < ApplicationRecord
    belongs_to :safety_inspection
    belongs_to :situation_condition
end
