class SurveillanceActivity < ApplicationRecord
  belongs_to :epidemiological_surveillance_program

  belongs_to :responsible,
             class_name: "User",
             optional: true

  enum status: {
    pending: 0,
    in_progress: 1,
    completed: 2,
    cancelled: 3
  }

  before_validation :set_execution_date_when_completed

  validates :name, presence: true

  validate :execution_date_after_planned_date
  validate :completed_requires_execution_date
  validate :cancelled_requires_observations
  validate :responsible_belongs_to_program_entity

  private

  def set_execution_date_when_completed
    if completed? && execution_date.blank?
      self.execution_date = Date.current
    end
  end

  def execution_date_after_planned_date
    return if planned_date.blank? || execution_date.blank?

    if execution_date < planned_date
      errors.add(
        :execution_date,
        "no puede ser anterior a la fecha programada"
      )
    end
  end

  def completed_requires_execution_date
    return unless completed?

    if execution_date.blank?
      errors.add(
        :execution_date,
        "debe registrarse cuando la actividad está completada"
      )
    end
  end

  def cancelled_requires_observations
    return unless cancelled?

    if observations.blank?
      errors.add(
        :observations,
        "deben registrarse cuando la actividad es cancelada"
      )
    end
  end

  def responsible_belongs_to_program_entity
    return if responsible.blank?
    return if epidemiological_surveillance_program.blank?

    unless responsible.entity == epidemiological_surveillance_program.entity_id
      errors.add(
        :responsible,
        "debe pertenecer a la misma entidad del programa SVE"
      )
    end
  end
end