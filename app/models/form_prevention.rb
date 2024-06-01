class FormPrevention < ApplicationRecord
    belongs_to :admin_extent_danger
    belongs_to :clasification_danger_detail
    belongs_to :clasification_danger
end
