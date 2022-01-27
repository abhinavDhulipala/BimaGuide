class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs do |t|
      t.integer :duration
      t.float :total_pay
      t.string :role
      t.references :employees, null: false, foreign_key: true

      t.timestamps
    end
  end
end
