class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :election, null: false, foreign_key: true
      t.integer :voter, index: true,  null: false
      t.integer :candidate, index: true, null: false
      t.datetime :created_at
    end
    add_index :votes, [:voter, :election_id], unique: true
  end
end
