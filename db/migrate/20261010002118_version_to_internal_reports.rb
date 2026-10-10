class VersionToInternalReports < ActiveRecord::Migration[7.0]
  def change
    add_column :internal_reports , :version, :integer, default: 0
    add_column :internal_reports, :code, :string
    add_column :adm_votes, :version, :integer, default: 0
    add_column :adm_votes, :code, :string
    add_column :templates, :participant_secretary, :integer, default: 0
    add_column :participants, :secretary_ccl, :integer, default: 0

  end
end
