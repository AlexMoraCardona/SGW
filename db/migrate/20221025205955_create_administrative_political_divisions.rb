class CreateAdministrativePoliticalDivisions < ActiveRecord::Migration[7.0]
  def change
    create_table :administrative_political_divisions do |t|
      t.string :department_code
      t.string :department_name
      t.string :municipality_code
      t.string :municipality_name
      t.string :town_center_code
      t.string :town_center_name
      t.string :type

      t.timestamps
    end
  end
end
