class CreateIntegrationItems < ActiveRecord::Migration
  def change
    create_table :integration_items do |t|
      t.string :item_name
      t.string :item_title
      t.string :item_description
      t.string :app_token
      t.string :consumer_key
      t.string :consumer_secret
      t.boolean :configured

      t.timestamps null: false
    end
  end
end
