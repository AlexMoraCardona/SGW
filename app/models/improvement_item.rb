class ImprovementItem < ApplicationRecord
    has_many_attached :file_improvements
    belongs_to :improvement_plan

end
