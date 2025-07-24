class CreateExchangeRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :exchange_requests do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.references :book, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
