class AddNombreToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :nombre, :string
  end
end
