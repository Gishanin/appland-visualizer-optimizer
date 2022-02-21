class CreateAppmapJsons < ActiveRecord::Migration[5.2]
  def change
    create_table :appmap_jsons do |t|
      t.string :path
      t.string :name
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
