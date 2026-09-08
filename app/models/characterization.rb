class Characterization < ApplicationRecord

  belongs_to :surveillance_worker

  enum pve_group: {high: 0, medium: 1, low: 2 }

  enum principal_exposure: {exposure_1: 0, exposure_2: 1, exposure_3: 2, exposure_4: 3, exposure_5: 4, exposure_6: 5, exposure_7: 6}

  enum frequency: {permanent: 0, occasional: 1}

  enum characterization_status: {current: 0, pending: 1, retired: 2, relocated: 3}

  validates :surveillance_worker, presence: true, uniqueness: true


  def self.principal_exposure_options
    [
      [
        "Vapores, aerosoles, gases, contacto con sustancias químicas, material particulado, humos de soldadura.",
        "exposure_1"
      ],
      [
        "Material particulado, almacenamiento, derrames.",
        "exposure_2"
      ],
      [
        "Vapores, aerosoles, gases, contacto con sustancias químicas, material particulado.",
        "exposure_3"
      ],
      [
        "Material particulado, almacenamiento, derrames, contacto con sustancias químicas.",
        "exposure_4"
      ],
      [
        "Material particulado, contacto con sustancias químicas.",
        "exposure_5"
      ],
      [
        "Gases, material particulado, humo metálico.",
        "exposure_6"
      ],
      [
        "Material particulado.",
        "exposure_7"
      ]
    ]
  end 
  
  def self.pve_group_options
    [
      ["A - Alta", "high"],
      ["M - Media", "medium"],
      ["B - Baja", "low"]
    ]
  end

  def self.frequency_options
    [
     ["Permanente", "permanent"],
      ["Ocasional", "occasional"]
    ]
  end

  def self.characterization_status_options
    [
      ["Vigente", "current"],
      ["Pendiente", "pending"],
      ["Retirado", "retired"],
      ["Reubicado", "relocated"]
    ]
  end

end