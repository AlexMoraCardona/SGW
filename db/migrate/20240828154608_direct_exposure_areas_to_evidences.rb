class DirectExposureAreasToEvidences < ActiveRecord::Migration[7.0]
  def change
    add_column :evidences, :direct_exposure_areas, :string
    add_column :evidences, :medical_examination_entity, :string
    add_column :evidences, :biologica_risk_area, :string
  end
end
