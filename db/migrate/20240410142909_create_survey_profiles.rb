class CreateSurveyProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_profiles do |t|
      t.date :date_profile
      t.date :date_vencimiento_profile

      t.timestamps
    end
    add_reference :survey_profiles, :entity, null: true, foreign_key: true
  end
end
