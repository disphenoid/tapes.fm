class CreateTapes < ActiveRecord::Migration
  def change
    create_table :tapes do |t|
      t.string :name
      t.integer :bpm

      t.timestamps
    end
  end
end
