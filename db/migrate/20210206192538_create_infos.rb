class CreateInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :infos do |t|
      t.references :project, null: false, foreign_key: true
      t.references :contributer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
