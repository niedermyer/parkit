class CreateParkingAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :parking_assignments do |t|
      t.references :space, foreign_key: true
      t.references :vehicle, foreign_key: true
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end

    add_index :parking_assignments, [:space_id, :ended_at], unique: true
  end
end
