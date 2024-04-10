class EntityToDescriptionJobs < ActiveRecord::Migration[7.0]
  def change
    add_reference :description_jobs, :entity, null: false, foreign_key: true
    change_column :description_jobs, :firm_elaboro, :integer, default: 0
    change_column :description_jobs, :firm_reviso, :integer, default: 0
    change_column :description_jobs, :firm_aprobo, :integer, default: 0
  end
end
