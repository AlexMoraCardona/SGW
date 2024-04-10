class CreateDescriptionJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :description_jobs do |t|
      t.string :name_job
      t.string :immediate_boss
      t.string :objetive_job
      t.string :academic_training
      t.string :experience
      t.string :salary_range
      t.string :type_contract
      t.string :working_hours
      t.string :required_knowledge
      t.string :competencies
      t.string :job_functions
      t.string :roles_responsibilities
      t.string :observations
      t.integer :user_elaboro
      t.integer :user_reviso
      t.integer :user_aprobo
      t.date :date_firm_elaboro
      t.date :date_firm_reviso
      t.date :date_firm_aprobo
      t.integer :firm_elaboro
      t.integer :firm_reviso
      t.integer :firm_aprobo
      t.integer :state_job

      t.timestamps
    end
  end
end
