class AddIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :github_events, :created_at, if_not_exists: true
    add_index :github_events, :actor_id, if_not_exists: true
    add_index :github_events, :actor_login, if_not_exists: true
    add_index :github_events, :repo_id, if_not_exists: true
    add_index :github_events, :repo_name, if_not_exists: true
    add_index :github_events, :language, if_not_exists: true
    add_index :github_events, :action, if_not_exists: true
    add_index :github_events, :is_oss_db, if_not_exists: true
    add_index :github_events, :type, if_not_exists: true
  end
end
