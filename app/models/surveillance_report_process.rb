class SurveillanceReportProcess < ApplicationRecord
  belongs_to :surveillance_report

  validates :process_name, presence: true
  validates :risks, presence: true

  validates :position, presence: true
end