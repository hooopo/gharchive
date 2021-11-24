class AddLabelsColumn < ActiveRecord::Migration[6.1]
  def change
    # issue & pr attributes
    add_column :github_events, :labels, :json
    add_column :github_events, :state, :string
    add_column :github_events, :locked, :boolean
    add_column :github_events, :closed_at, :datetime
    add_column :github_events, :comments, :integer
    add_column :github_events, :milestone, :string

    # pr attributes
    add_column :github_events, :pr_merged_at, :datetime
    add_column :github_events, :pr_draft, :boolean
    add_column :github_events, :pr_merged, :boolean
    add_column :github_events, :pr_changed_files, :integer
    add_column :github_events, :pr_review_comments, :integer

    add_column :github_events, :github_staff, :boolean
    add_column :github_events, :pr_or_issue_id, :bigint

    # push
    add_column :github_events, :email_domain, :string
  end
end
