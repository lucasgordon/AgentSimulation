class ChangeTemperatureAndTopPToFloat < ActiveRecord::Migration[7.1]
  def change
    change_column :agents, :temperature, :float
    change_column :agents, :top_p, :float
  end
end
