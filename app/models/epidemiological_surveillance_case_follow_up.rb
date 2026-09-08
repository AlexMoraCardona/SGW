class EpidemiologicalSurveillanceCaseFollowUp < ApplicationRecord

  belongs_to :epidemiological_surveillance_case
  belongs_to :user
  has_many_attached :follow_up_files

  enum follow_up_type: {
    identification: 0,
    initial_evaluation: 1,
    follow_up: 2,
    visit: 3,
    phone_contact: 4,
    document_review: 5,
    closure: 6
  }

  enum status: {
    identified: 0,
    in_evaluation: 1,
    in_follow_up: 2,
    closed: 3,
    not_case: 4
  }

  validates :follow_up_date, presence: true
  validate :result_required_when_closed

  private

  def result_required_when_closed
    if closed? && result.blank?
      errors.add(:result, "debe registrarse para cerrar el caso")
    end
  end

end