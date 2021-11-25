class AddIdxForQuery < ActiveRecord::Migration[6.1]
  def change
    add_index :github_events, :event_year, if_not_exists: true
    add_index :github_events, :event_month, if_not_exists: true
    add_index :github_events, :event_day, if_not_exists: true
    add_index :github_events, :email_domain, if_not_exists: true
    add_index :github_events, :pr_or_issue_id, if_not_exists: true
    add_index :github_events, :github_staff, if_not_exists: true
    add_index :github_events, :pr_review_comments, if_not_exists: true
    add_index :github_events, :pr_changed_files, if_not_exists: true
    add_index :github_events, :pr_merged, if_not_exists: true
    add_index :github_events, :pr_draft, if_not_exists: true
    add_index :github_events, :pr_merged_at, if_not_exists: true
    add_index :github_events, :milestone, if_not_exists: true
    add_index :github_events, :comments, if_not_exists: true
    add_index :github_events, :closed_at, if_not_exists: true
    add_index :github_events, :locked, if_not_exists: true
    add_index :github_events, :state, if_not_exists: true
    add_index :github_events, :org_id, if_not_exists: true
    add_index :github_events, :org_login, if_not_exists: true
    add_index :github_events, :comment_id, if_not_exists: true
    add_index :github_events, :commit_id, if_not_exists: true
    add_index :github_events, :number, if_not_exists: true
    add_index :github_events, :deletions, if_not_exists: true
    add_index :github_events, :additions, if_not_exists: true
    add_index :github_events, :actor_location, if_not_exists: true
    add_index :github_events, :actor_id, if_not_exists: true 
  end
end



 
    