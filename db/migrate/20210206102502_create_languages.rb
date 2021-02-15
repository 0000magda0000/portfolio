class CreateLanguages < ActiveRecord::Migration[6.0]
  def change
    create_table :languages do |t|
      t.string :name
      t.integer :statistics

      t.timestamps
    end
  end
end
