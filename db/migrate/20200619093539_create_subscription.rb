class CreateSubscription < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.string :email, null: false
      t.boolean :email_confirmed, default: false
      t.string :confirm_token
      t.references :user, index: true, null: false

      t.timestamps null: false
    end
  end
end
