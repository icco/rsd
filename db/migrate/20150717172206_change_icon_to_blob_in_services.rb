class ChangeIconToBlobInServices < ActiveRecord::Migration
  def up
    # Postgres didn't like change_column and there's no data in here anyway.
    remove_column :services, :icon
    add_column :services, :icon, :binary, after: :name
  end

  def down
    remove_column :services, :icon
    add_column :services, :icon, :string, after: :name
  end
end
