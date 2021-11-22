class AddRepoIdAndRepoName < ActiveRecord::Migration[6.1]
  def change
    add_column :github_events, :repo_id, :string
    add_column :github_events, :repo_name, :string
  end
end
