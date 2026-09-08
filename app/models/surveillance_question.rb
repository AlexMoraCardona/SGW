class SurveillanceQuestion < ApplicationRecord
  belongs_to :surveillance_survey
  has_many :surveillance_question_options,
           -> { order(:position) },
           dependent: :destroy

  has_many :surveillance_answers,
         dependent: :restrict_with_error

  enum question_type: {
    open_text: 0,
    boolean: 1,
    single_choice: 2,
    multiple_choice: 3
  }

  validates :question, presence: true
  validates :position, presence: true
end