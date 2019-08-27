class AddSvaJsonDataToRecord < ActiveRecord::Migration[6.0]
  def change
    add_column :records, :sva_json_data, :jsonb
  end
end
