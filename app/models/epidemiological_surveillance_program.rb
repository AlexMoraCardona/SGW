class EpidemiologicalSurveillanceProgram < ApplicationRecord
  belongs_to :entity
  belongs_to :responsible, class_name: 'User', optional: true
  belongs_to :surveillance_configuration, optional: true

  has_many :surveillance_surveys, dependent: :destroy
  has_many :surveillance_workers, dependent: :destroy
  has_many :surveillance_activities, dependent: :destroy
  has_many :epidemiological_surveillance_cases, dependent: :restrict_with_error
  has_many :surveillance_inspections, dependent: :destroy
  
  has_one :surveillance_report, dependent: :destroy

  enum status: {
    draft: 0,
    active: 1,
    closed: 2,
    inactive: 3
  }

  validates :name, presence: true
  
end