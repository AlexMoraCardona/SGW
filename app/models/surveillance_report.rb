class SurveillanceReport < ApplicationRecord

  belongs_to :epidemiological_surveillance_program

  has_many :surveillance_report_populations,
           dependent: :destroy

  has_many :surveillance_report_processes,
           dependent: :destroy

  has_many :surveillance_report_hazards,
           dependent: :destroy


  accepts_nested_attributes_for :surveillance_report_populations,
                                allow_destroy: true

  accepts_nested_attributes_for :surveillance_report_processes,
                                allow_destroy: true

  accepts_nested_attributes_for :surveillance_report_hazards,
                                allow_destroy: true


  enum status: {
    draft: 0,
    finalized: 1
  }


  validates :epidemiological_surveillance_program,
            uniqueness: true

  validates :number_of_workers,
            numericality: {
              greater_than_or_equal_to: 0
            },
            allow_nil: true

  validate :fecha_firma_valida


  private


  def fecha_firma_valida

    if autoriza_firma && fecha_firma.blank?

      errors.add(
        :fecha_firma,
        "debe indicar la fecha de firma"
      )

    end

  end

end
