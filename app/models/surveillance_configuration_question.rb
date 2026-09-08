class SurveillanceConfigurationQuestion < ApplicationRecord

  belongs_to :surveillance_configuration

  has_many :surveillance_configuration_question_options,
           -> { order(position: :asc) },
           dependent: :destroy

  enum question_type: {
    open_text: 0,
    boolean: 1,
    single_choice: 2,
    multiple_choice: 3
  }
  
  enum status: {
    active: 0,
    inactive: 1
  }

  validates :question, presence: true
  validates :position, presence: true

end
