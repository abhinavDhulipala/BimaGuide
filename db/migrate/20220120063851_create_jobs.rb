class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs do |t|
      t.integer :duration
      t.float :total_pay
      t.string :role
      t.datetime :date_completed

      t.timestamps
    end
    add_belongs_to :jobs, :employee
  end
end
