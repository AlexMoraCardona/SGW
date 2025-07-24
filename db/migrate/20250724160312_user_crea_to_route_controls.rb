class UserCreaToRouteControls < ActiveRecord::Migration[7.0]
  def change
    add_column :route_controls, :user_create, :integer, default: 0
    add_column :route_controls, :entity, :integer, default: 0
  end
end
