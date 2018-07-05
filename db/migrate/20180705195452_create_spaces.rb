class CreateSpaces < ActiveRecord::Migration[5.2]
  def change
    create_table :spaces do |t|
      t.integer :floor
      t.string :section
      t.integer :number

      t.timestamps
    end
  end
end
