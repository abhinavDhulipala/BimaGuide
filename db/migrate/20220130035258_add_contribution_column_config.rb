class AddContributionColumnConfig < ActiveRecord::Migration[6.1]
  def change
    add_column :configs, :max_contribution_amount, :integer
    add_column :configs, :max_contribution_freq, :integer
  end
end
