class CreateUsages < ActiveRecord::Migration
  def change
    create_table :usages do |t|
      t.integer   :feature_id
      t.integer   :total, default: 0
      t.integer   :used,  default: 0
      t.integer   :duration
      t.float     :usage
      t.float     :wu
      t.timestamp :start_at
      t.timestamp :stop_at
      t.timestamps
    end
  end
end
