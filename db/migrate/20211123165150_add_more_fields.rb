class AddMoreFields < ActiveRecord::Migration[6.1]
  def change
    add_column :github_events, :number, :integer
    add_column :github_events, :commit_id, :bigint
    add_column :github_events, :comment_id, :bigint
    add_column :github_events, :body, :text
  end
end
