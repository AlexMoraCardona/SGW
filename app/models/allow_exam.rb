class AllowExam < ApplicationRecord
    belongs_to :user
    belongs_to :adm_exam
    belongs_to :entity
end
