class CreateSlackChannel < ActiveRecord::Migration[6.0]
  def change
    create_table :slack_channels do |t|
      t.string :name, null: false
      t.string :webhook_url, null: false, unique: true
      t.references :user, index: true, null: false

      t.timestamps null: false
    end
  end
end
