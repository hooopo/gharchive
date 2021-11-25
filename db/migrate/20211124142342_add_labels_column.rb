class AddLabelsColumn < ActiveRecord::Migration[6.1]
  def change
    # issue & pr attributes
    add_column :github_events, :labels, :json
    add_column :github_events, :state, :string, index: true
    add_column :github_events, :locked, :boolean, index: true
    add_column :github_events, :closed_at, :datetime, index: true
    add_column :github_events, :comments, :integer, index: true
    add_column :github_events, :milestone, :string, index: true

    # pr attributes
    add_column :github_events, :pr_merged_at, :datetime, index: true
    add_column :github_events, :pr_draft, :boolean, index: true
    add_column :github_events, :pr_merged, :boolean, index: true
    add_column :github_events, :pr_changed_files, :integer, index: true
    add_column :github_events, :pr_review_comments, :integer, index: true

    add_column :github_events, :github_staff, :boolean, index: true
    add_column :github_events, :pr_or_issue_id, :bigint, index: true

    # push
    add_column :github_events, :email_domain, :string, index: true
  end
end
