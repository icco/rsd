class AddMobileUrlToServices < ActiveRecord::Migration
  def change
    add_column :services, :mobile_url, :string, :null => true
  end
end
