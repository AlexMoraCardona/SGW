class EpidemiologicalSurveillanceCaseHistory < ApplicationRecord

  belongs_to :epidemiological_surveillance_case
  belongs_to :user
  validates :changed_at, presence: true

end