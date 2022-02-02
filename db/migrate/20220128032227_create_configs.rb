class CreateConfigs < ActiveRecord::Migration[6.1]
  def change
    create_table :configs, id: false do |t|
      t.string :conf, unique: true, null: false, primary_key: true
      t.integer :value, null: false
      t.integer :units, null: false
    end
  end
end
