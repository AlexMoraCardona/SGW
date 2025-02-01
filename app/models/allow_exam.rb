class AllowExam < ApplicationRecord
    belongs_to :user
    belongs_to :adm_exam
    belongs_to :entity

    has_many :exams
end
