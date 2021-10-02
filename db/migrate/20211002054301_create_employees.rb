class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.string :role
      t.integer :contributions
      t.string :email
      t.string :occupation

      t.timestamps
    end
    add_index :employees, :email, unique: true
  end
end
