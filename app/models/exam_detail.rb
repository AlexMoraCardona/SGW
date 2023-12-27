class ExamDetail < ApplicationRecord
    belongs_to :exam
    belongs_to :exam_question
end
