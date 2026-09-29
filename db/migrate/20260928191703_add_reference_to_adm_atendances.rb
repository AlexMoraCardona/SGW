class AddReferenceToAdmAtendances < ActiveRecord::Migration[7.0]
  def change
    add_column :adm_attendances, :version, :integer, default: 0
    add_column :adm_attendances, :code, :string
    add_column :adm_extinguishers, :version, :integer, default: 0
    add_column :adm_extinguishers, :code, :string
    add_column :kits, :version, :integer, default: 0
    add_column :kits, :code, :string
    add_column :adm_exams, :version, :integer, default: 0
    add_column :adm_exams, :code, :string
    add_column :view_videos, :version, :integer, default: 0
    add_column :view_videos, :code, :string
    add_column :meeting_minutes, :vers, :integer, default: 0
  end
end
