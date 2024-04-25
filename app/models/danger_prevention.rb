class DangerPrevention < ApplicationRecord
    belongs_to :clasification_danger_detail
    has_many :form_preventions
end
