class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :name
      t.integer :price
      t.references :country, index: true
      t.integer :cost

      t.timestamps
    end
  end
end
