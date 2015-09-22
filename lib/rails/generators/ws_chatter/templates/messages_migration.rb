class Create<%= messages_table.camelize %> < ActiveRecord::Migration
  def change
    create_table :<%= messages_table %> do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.text :body
      t.boolean :unread, default: true

      t.timestamps null: false
    end
    add_index :<%= messages_table %>, :sender_id
    add_index :<%= messages_table %>, :recipient_id
  end
end
