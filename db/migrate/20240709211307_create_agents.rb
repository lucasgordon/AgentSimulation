class CreateAgents < ActiveRecord::Migration[7.1]
  def change
    create_table :agents do |t|

      t.timestamps
      t.string "name"
      t.string "system_prompt"
      t.string "temperature"
      t.string "model"
    end
  end
end
