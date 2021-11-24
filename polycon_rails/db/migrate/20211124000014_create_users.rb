class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.belongs_to :role, null: false, foreign_key: true

      t.timestamps
    end
    add_index :users, :name, unique: true
  end
end
