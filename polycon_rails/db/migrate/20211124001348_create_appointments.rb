class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone, null: false
      t.string :note
      t.datetime :date, null: false
      t.belongs_to :professional, null: false, foreign_key: true

      t.timestamps
    end
  end
end
