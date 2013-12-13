class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.integer   :feature_id
      t.integer   :user_id
      t.integer   :workstation_id
      t.integer   :pid
      t.integer   :count
      t.string    :signature
      t.integer   :slot
      t.integer   :duration
      t.timestamp :start_at
      t.timestamp :stop_at
      t.timestamps
    end
  end
end
