class SurveillanceConfigurationQuestionOption < ApplicationRecord

  belongs_to :surveillance_configuration_question

  enum status: {
    active: 0,
    inactive: 1
  }

  validates :option, presence: true
  validates :position, presence: true

end
