class SurveillanceAnswerOption < ApplicationRecord
  belongs_to :surveillance_answer
  belongs_to :surveillance_question_option

  validates :surveillance_question_option_id, uniqueness: {scope: :surveillance_answer_id}
end