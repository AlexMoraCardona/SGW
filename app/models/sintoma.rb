class Sintoma < ApplicationRecord

  belongs_to :surveillance_worker


  enum accion_sst: {
    sin_hallazgos: 0,
    orientacion: 1,
    remision_valoracion_medica: 2,
    seguimiento: 3,
    investigacion_caso: 4,
    activacion_conglomerado: 5,
    medida_preventiva_area: 6
  }


  enum seguimiento: {
    no_requiere: 0,
    en_seguimiento: 1,
    remitido_eps: 2,
    cerrado: 3
  }


  validates :surveillance_worker,
            presence: true,
            uniqueness: true


  validate :otro_cual_required


  def self.accion_sst_options

    [
      ["Sin hallazgos", "sin_hallazgos"],
      ["Orientación", "orientacion"],
      ["Remisión a valoración médica", "remision_valoracion_medica"],
      ["Seguimiento", "seguimiento"],
      ["Investigación de caso", "investigacion_caso"],
      ["Activación de conglomerado", "activacion_conglomerado"],
      ["Medida preventiva en área", "medida_preventiva_area"]
    ]

  end


  def self.seguimiento_options

    [
      ["No requiere", "no_requiere"],
      ["En seguimiento", "en_seguimiento"],
      ["Remitido a EPS", "remitido_eps"],
      ["Cerrado", "cerrado"]
    ]

  end


  private


  def otro_cual_required

    if otro? && otro_cual.blank?

      errors.add(
        :otro_cual,
        "debe especificarse cuando se selecciona 'Otro'"
      )

    end

  end

end