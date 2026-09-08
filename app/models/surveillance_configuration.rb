class SurveillanceConfiguration < ApplicationRecord
  has_many :detail_diseases
  has_many :surveillance_configuration_questions,
           -> { order(position: :asc) },
           dependent: :destroy

  has_many :epidemiological_surveillance_programs,
           dependent: :nullify

  enum status: {
    active: 0,
    inactive: 1
  }

  validates :name, presence: true, uniqueness: true

end