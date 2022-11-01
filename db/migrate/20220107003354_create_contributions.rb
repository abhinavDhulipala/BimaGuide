# frozen_string_literal: true

class CreateContributions < ActiveRecord::Migration[6.1]
  def change
    create_table :contributions do |t|
      t.float :amount, null: false
      t.text :purpose, null: false
      t.timestamps
    end
    add_belongs_to :contributions, :employee
  end
end
