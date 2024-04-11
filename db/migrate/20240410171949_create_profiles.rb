class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.integer :gender, default: 0
      t.integer :blood_type, default: 0
      t.integer :age, default: 0
      t.integer :weight, default: 0
      t.integer :height, default: 0
      t.integer :civil_status, default: 0
      t.integer :education_level, default: 0
      t.string :secretariat_belongs
      t.string :dependency_belongs
      t.string :post_actual
      t.integer :contract_type, default: 0
      t.integer :salary_range, default: 0
      t.string :emergency_contact
      t.string :phone_emergency_contact
      t.integer :population_group, default: 0
      t.string :address
      t.string :neighborhood
      t.string :phone
      t.integer :stratum_socioeconomic, default: 0
      t.integer :housing_type, default: 0
      t.integer :basic_housing_services, default: 0
      t.integer :head_family, default: 0
      t.integer :has_children, default: 0
      t.integer :number_children, default: 0
      t.integer :number_people_charge, default: 0
      t.integer :live_people_disability, default: 0
      t.integer :type_disability, default: 0
      t.integer :use_time, default: 0
      t.integer :diagnosed_illness, default: 0
      t.string :what_disease
      t.integer :smoke, default: 0
      t.string :daily_average_smoke
      t.integer :consume_alcoholic_beverages, default: 0
      t.integer :average_drinks, default: 0
      t.integer :sports_practice, default: 0
      t.integer :average_sports, default: 0
      t.integer :conveyance, default: 0
      t.integer :accept_processing_data, default: 0

      t.timestamps
    end
    add_reference :profiles, :user, null: true, foreign_key: true
    add_reference :profiles, :survey_profile, null: true, foreign_key: true
    add_reference :profiles, :health_promoter, null: true, foreign_key: true
    add_reference :profiles, :pension_fund, null: true, foreign_key: true
    add_reference :profiles, :occupational_risk_manager, null: true, foreign_key: true
    add_reference :profiles, :administrative_political_division, null: true, foreign_key: true
  end
end
