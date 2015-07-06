class ChangeMobileUrlToMobileUriInAccounts < ActiveRecord::Migration
  def change
    rename_column :accounts, :mobile_url, :mobile_uri
  end
end
