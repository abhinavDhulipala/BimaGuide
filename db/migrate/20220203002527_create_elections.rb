class CreateElections < ActiveRecord::Migration[6.1]
  def change
    create_table :elections do |t|
      t.boolean :active
      t.boolean :vetoed
      t.datetime :ends_at
      t.integer :winner, index: true
      t.timestamps
    end
  end
end
