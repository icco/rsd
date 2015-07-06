class AddMobileUrlToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :mobile_url, :string, :null => true
  end
end
