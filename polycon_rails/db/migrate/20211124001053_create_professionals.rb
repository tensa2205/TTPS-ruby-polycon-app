class CreateProfessionals < ActiveRecord::Migration[6.1]
  def change
    create_table :professionals do |t|
      t.string :full_name, null: false

      t.timestamps
    end
    add_index :professionals, :full_name, unique: true
  end
end
