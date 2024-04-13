class FirmToSurveyProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :survey_profiles, :user_elaboro, :integer
    add_column :survey_profiles, :user_reviso, :integer
    add_column :survey_profiles, :user_aprobo, :integer
    add_column :survey_profiles, :date_firm_elaboro, :date
    add_column :survey_profiles, :date_firm_reviso, :date
    add_column :survey_profiles, :date_firm_aprobo, :date
    add_column :survey_profiles, :firm_elaboro, :integer, default: 0
    add_column :survey_profiles, :firm_aprobo, :integer, default: 0
    add_column :survey_profiles, :firm_reviso, :integer, default: 0
  end
end



