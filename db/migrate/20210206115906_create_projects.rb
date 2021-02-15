class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :website
      t.string :github_link
      t.date :first_push
      t.date :latest_push

      t.timestamps
    end
  end
end
