class UserRepresentanteToEvaluations < ActiveRecord::Migration[7.0]
  def change
    add_column :evaluations, :user_responsible, :integer, default: 0
    add_column :evaluations, :date_firm_responsible, :date
    add_column :evaluations, :firm_responsible, :integer, default: 0
    add_column :evaluations, :user_representante, :integer, default: 0
    add_column :evaluations, :date_firm_representante, :date
    add_column :evaluations, :firm_representante, :integer, default: 0
  end
end



