class CreateWorkstations < ActiveRecord::Migration
  def change
    create_table :workstations do |t|
      t.string :hostname

      t.timestamps
    end
  end
end
