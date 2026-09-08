class SurveillanceAnswer < ApplicationRecord
  belongs_to :surveillance_survey_response
  belongs_to :surveillance_question

  has_many :surveillance_answer_options, dependent: :destroy
 
  validates :surveillance_question_id, uniqueness: {scope: :surveillance_survey_response_id}
  
end