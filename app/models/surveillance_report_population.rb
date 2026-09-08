class SurveillanceReportPopulation < ApplicationRecord
  belongs_to :surveillance_report

  validates :priority, presence: true
  validates :exposure, presence: true

  validates :number_exposed,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  validates :position, presence: true
end