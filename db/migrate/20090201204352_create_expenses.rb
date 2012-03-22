class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table(:expenses) do |t|
      t.integer :user_id, null: false
      t.float   :cost,    null: false, size: "8,2"
      t.string  :item,    null: false
      t.timestamps
    end
  end

  def self.down
    drop_table :expenses
  end
end
