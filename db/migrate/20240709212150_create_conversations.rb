class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations do |t|

      t.timestamps
      t.references :agent, null: false, foreign_key: true
      t.text :message
    end
  end
end
