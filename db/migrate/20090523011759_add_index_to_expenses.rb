class AddIndexToExpenses < ActiveRecord::Migration
  def self.up
    add_index :expenses, :user_id
  end

  def self.down
    remove_index :expenses, :user_id
  end
end