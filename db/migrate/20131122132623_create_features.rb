class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string      :name
      t.string      :nick
      t.integer     :used,   default: 0
      t.integer     :total,  default: 0
      t.string      :custom_color
      t.boolean     :visible, default: true
      t.timestamp   :since
      t.timestamp   :last_seen_at
      t.timestamps
    end
  end
end
