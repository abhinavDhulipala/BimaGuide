class CreateClaims < ActiveRecord::Migration[6.1]
  def change
    create_table :claims do |t|
      t.references :employee, {null: false, foreign_key: true}
      t.boolean :approved, null: false
      t.integer :amount, null: false
      t.integer :approver_id, null: false
      t.integer :type, null: false
      t.text :info, null: false
      t.datetime :occurred, null: false
      t.boolean :edit_required

      t.timestamps
    end

    add_index :claims, :approver_id
  end
end
