class CreateVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicles do |t|
      t.string :license_state, null: false
      t.string :license_number, null: false
      t.string :description
      t.string :contact_name
      t.string :contact_phone

      t.timestamps
    end
  end
end
