class AreaToDescriptionJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :description_jobs, :area, :integer, default: 0
    add_column :description_jobs, :risks_steps, :string
    add_column :description_jobs, :risks_peligro, :string
    add_column :description_jobs, :risks_salud, :string
    add_column :description_jobs, :epp_requested, :string
    add_column :description_jobs, :type_evaluation, :string
    add_column :description_jobs, :enfasis, :string
  end
end
