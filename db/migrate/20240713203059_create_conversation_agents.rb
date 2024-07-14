class CreateConversationAgents < ActiveRecord::Migration[7.1]
  def change
    create_table :conversation_agents do |t|
      t.references :agent, null: false, foreign_key: true
      t.references :conversation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
