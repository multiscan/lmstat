class AddVisibleToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :visible, :boolean, :default => true
  end
end
