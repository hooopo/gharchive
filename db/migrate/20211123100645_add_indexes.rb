class AddIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :github_events, :created_at
    add_index :github_events, :actor_id
    add_index :github_events, :actor_login
    add_index :github_events, :repo_id
    add_index :github_events, :repo_name
    add_index :github_events, :language
    add_index :github_events, :action 
    add_index :github_events, :is_oss_db
    add_index :github_events, :type
  end
end
