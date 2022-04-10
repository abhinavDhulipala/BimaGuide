class CreateClaims < ActiveRecord::Migration[6.1]
  def change
    create_table :claims do |t|
      t.float :amount
      t.text :reason
      t.references :employee, null: false, foreign_key: true
      t.bigint :approver
      t.datetime :ends_at

      t.timestamps
    end
  end
end
