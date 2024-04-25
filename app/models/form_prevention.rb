class FormPrevention < ApplicationRecord
    belongs_to :user
    belongs_to :admin_extent_danger
    belongs_to :danger_prevention
end
