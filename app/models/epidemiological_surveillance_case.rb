class EpidemiologicalSurveillanceCase < ApplicationRecord

  belongs_to :epidemiological_surveillance_program
  belongs_to :entity
  belongs_to :user
  belongs_to :event, optional: true
  belongs_to :surveillance_survey_response, optional: true
  belongs_to :responsible, class_name: 'User', optional: true
  has_many :follow_ups, class_name: 'EpidemiologicalSurveillanceCaseFollowUp', dependent: :destroy 
  has_many :epidemiological_surveillance_case_histories, dependent: :destroy         

  enum source_type: {
    event: 0,
    survey: 1,
    other: 2
  }

  enum status: {
    identified: 0,
    in_evaluation: 1,
    in_follow_up: 2,
    closed: 3,
    not_case: 4
  }

  enum return_to_work: {
    not_applicable: 0,
    pending_return: 1,
    return_without_restrictions: 2,
    return_with_recommendations: 3,
    pending_medical_opinion: 4
  }
    
  validates :opened_at, presence: true

end