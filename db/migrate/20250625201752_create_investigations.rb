class CreateInvestigations < ActiveRecord::Migration[7.0]
  def change
    create_table :investigations do |t|
      t.date :date_investigation
      t.integer :type_event, default: 0
      t.integer :accident_usual, default: 0
      t.string :obs_accident_usual
      t.string :type_labor_connection
      t.integer :age, default: 0
      t.string :job_experience
      t.date :date_income
      t.string :area
      t.integer :phone, default: 0
      t.date :date_accident
      t.time :time_accident
      t.string :place
      t.integer :inform_prompt, default: 0
      t.string :obs_inform_prompt
      t.string :task_moment_accident
      t.string :descript
      t.text :event_description
      t.text :version_work
      t.text :version_witness
      t.integer :similar_events, default: 0
      t.string :obs_similar_events
      t.text :complementary_data
      t.text :photographic_record
      t.string :immediate_cause1
      t.string :immediate_cause2
      t.string :immediate_cause3
      t.string :cause_basic1
      t.string :cause_basic2
      t.string :cause_basic3
      t.text :plan_action
      t.text :unsafe_acts
      t.text :unsafe_conditions
      t.text :personal_factors
      t.text :adm_factors
      t.string :affected_part
      t.string :type_injury
      t.string :accident_mechanism
      t.integer :disability_days, default: 0
      t.integer :usr_profesional, default: 0
      t.string :name_profesional
      t.integer :firm_profesional, default: 0
      t.date :date_firm_profesional
      t.string :license

      t.timestamps
    end
    add_reference :investigations, :entity, null: true, foreign_key: true
    add_reference :investigations, :user, null: true, foreign_key: true
  end
end
