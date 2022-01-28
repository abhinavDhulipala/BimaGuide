class CreateConfigs < ActiveRecord::Migration[6.1]
  def change
    create_table :configs do |t|
      t.integer :min_jobs
      t.integer :latest_job
      t.integer :latest_contribution
      t.integer :min_contributions

      t.timestamps
    end
  end
end
