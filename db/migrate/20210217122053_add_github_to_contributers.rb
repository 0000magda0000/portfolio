class AddGithubToContributers < ActiveRecord::Migration[6.0]
  def change
    add_column :contributers, :github, :string
  end
end
