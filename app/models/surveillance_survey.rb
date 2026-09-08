class SurveillanceSurvey < ApplicationRecord
  belongs_to :epidemiological_surveillance_program
  belongs_to :created_by, class_name: 'User', optional: true

  has_many :surveillance_questions,
           -> { order(:position) },
           dependent: :destroy

  has_many :surveillance_survey_responses,
           dependent: :restrict_with_error

  validates :name, presence: true
end