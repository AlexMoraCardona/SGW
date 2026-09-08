class SurveillanceSurveyResponse < ApplicationRecord
  belongs_to :surveillance_survey
  belongs_to :user
  belongs_to :entity
  belongs_to :reviewed_by, class_name: 'User', optional: true
  has_many :surveillance_answers, dependent: :destroy
  has_one :epidemiological_surveillance_case, dependent: :nullify           

  enum review_status: {
    review_pending: 0,
    reviewed: 1
  }

  enum status: {
    pending: 0,
    in_evaluation: 1,
    in_follow_up: 2,
    closed: 3,
    not_candidate: 4
  }

  validates :response_date, presence: true
  
end