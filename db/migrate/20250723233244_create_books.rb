class CreateBooks < ActiveRecord::Migration[7.2]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :genre
      t.integer :year
      t.text :synopsis
      t.text :details
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
