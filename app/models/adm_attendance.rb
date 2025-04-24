class AdmAttendance < ApplicationRecord
    belongs_to :entity
    belongs_to :user
end
