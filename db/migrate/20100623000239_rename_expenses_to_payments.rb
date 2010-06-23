class RenameExpensesToPayments < ActiveRecord::Migration
  def self.up
    rename_table :expenses, :payments
  end

  def self.down
    rename_table :payments, :expenses
  end
end
