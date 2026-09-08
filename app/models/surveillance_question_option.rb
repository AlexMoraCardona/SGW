class SurveillanceQuestionOption < ApplicationRecord
  belongs_to :surveillance_question

  has_many :surveillance_answer_options, dependent: :restrict_with_error
  validates :option_text, presence: true
  validates :position, presence: true
  
end