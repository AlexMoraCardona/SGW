class SurveillanceWorker < ApplicationRecord

  belongs_to :epidemiological_surveillance_program
  belongs_to :user

  has_one :characterization, dependent: :destroy
  has_one :sintoma, dependent: :destroy

  enum status: {
    active: 0,
    inactive: 1
  }

  validates :entry_date, presence: true

  validates :user_id,
            uniqueness: {
              scope: :epidemiological_surveillance_program_id,
              message: "ya está registrado en este programa SVE"
            }

  validate :exit_date_after_entry_date

  private

  def exit_date_after_entry_date

    return if exit_date.blank? || entry_date.blank?

    if exit_date < entry_date
      errors.add(
        :exit_date,
        "no puede ser anterior a la fecha de ingreso"
      )
    end
  end

end