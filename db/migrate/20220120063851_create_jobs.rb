# frozen_string_literal: true

class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs do |t|
      t.float :total_pay
      t.string :role
      t.datetime :date_completed
      t.datetime :date_started

      t.timestamps
    end
    add_belongs_to :jobs, :employee
  end
end
