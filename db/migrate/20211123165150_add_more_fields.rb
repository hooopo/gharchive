class AddMoreFields < ActiveRecord::Migration[6.1]
  def change
    add_column :github_events, :number, :integer, index: true
    add_column :github_events, :commit_id, :bigint, index: true
    add_column :github_events, :comment_id, :bigint, index: true
    add_column :github_events, :body, :text
  end
end
