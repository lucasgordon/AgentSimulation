class ChangeAgents < ActiveRecord::Migration[7.1]
  def change
    change_table :agents do |t|
      t.remove :temperature, :system_prompt
      t.change :name, :string
      t.column :temperature, :integer
      t.column :system_prompt, :text
      t.column :top_p, :integer
      t.change :model, :string
    end
  end
end
