class SurveillanceReportHazard < ApplicationRecord
  belongs_to :surveillance_report

  validates :agent, presence: true
  validates :substance_product, presence: true
  validates :possible_effects, presence: true

  validates :position, presence: true
end