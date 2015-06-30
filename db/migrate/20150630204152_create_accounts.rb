class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.belongs_to :user, index:true
      t.belongs_to :service, index:true
      t.string :uri

      t.timestamps null: false
    end
  end
end
