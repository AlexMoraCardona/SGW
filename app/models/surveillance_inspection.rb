class SurveillanceInspection < ApplicationRecord
  belongs_to :epidemiological_surveillance_program
  belongs_to :company_area

  enum control_fuente: {
    si: 0,
    no: 1,
    na: 2
  }, _prefix: true

  enum extraccion_operativa: {
    si: 0,
    no: 1,
    na: 2
  }, _prefix: true

  enum sin_obstrucciones: {
    si: 0,
    no: 1,
    na: 2
  }, _prefix: true

  enum mantenimiento_vigente: {
    si: 0,
    no: 1,
    na: 2
  }, _prefix: true

  enum fugas_derrames_controlados: {
    si: 0,
    no: 1,
    na: 2
  }, _prefix: true

  enum almacenamiento_adecuado: {
    si: 0,
    no: 1,
    na: 2
  }, _prefix: true

  enum epp_disponible: {
    si: 0,
    no: 1,
    na: 2
  }, _prefix: true

  enum uso_adecuado: {
    si: 0,
    no: 1,
    na: 2
  }, _prefix: true

  enum ventilacion_areas_comunes: {
    si: 0,
    no: 1,
    na: 2
  }, _prefix: true

  enum estado: {
    abierta: 0,
    en_ejecucion: 1,
    verificacion: 2,
    cerrada: 3,
    vencida: 4
  }

  validates :fecha, presence: true
  validates :inspector, presence: true
  validates :fuente_emision, presence: true
  validates :company_area, presence: true

  validate :company_area_belongs_to_program_entity


  def self.si_no_na_options
    [
        ["Sí", "si"],
        ["No", "no"],
        ["NA", "na"]
    ]
  end

  def self.estado_options
    [
      ["Abierta", "abierta"],
        ["En ejecución", "en_ejecucion"],
        ["Verificación", "verificacion"],
        ["Cerrada", "cerrada"],
        ["Vencida", "vencida"]
    ]
  end  
  
  def estado_label
    {
      "abierta" => "Abierta",
      "en_ejecucion" => "En ejecución",
      "verificacion" => "Verificación",
      "cerrada" => "Cerrada",
      "vencida" => "Vencida"
    }[estado] || estado
  end

  def estado_badge_class
    {
      "abierta" => "text-bg-warning",
      "en_ejecucion" => "text-bg-primary",
      "verificacion" => "text-bg-info",
      "cerrada" => "text-bg-success",
      "vencida" => "text-bg-danger"
    }[estado] || "text-bg-secondary"
  end
  
  private

  def company_area_belongs_to_program_entity
    return if company_area.blank?
    return if epidemiological_surveillance_program.blank?

    unless company_area.entity_id == epidemiological_surveillance_program.entity_id
      errors.add(
        :company_area,
        "no pertenece a la empresa del programa SVE"
      )
    end
  end
end