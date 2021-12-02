# == Schema Information
#
# Table name: github_events
#
#  id                 :string(255)      not null, primary key
#  action             :string(255)
#  actor_location     :string(255)
#  actor_login        :string(255)
#  additions          :bigint
#  body               :text(65535)
#  closed_at          :datetime
#  comments           :integer
#  deletions          :bigint
#  event_day          :string(255)
#  event_month        :string(255)
#  event_year         :integer
#  ext1               :string(255)
#  ext2               :string(255)
#  github_staff       :boolean
#  is_oss_db          :boolean          default(FALSE)
#  labels             :json
#  language           :string(255)
#  locked             :boolean
#  milestone          :string(255)
#  number             :integer
#  org_login          :string(255)
#  other              :json
#  pr_changed_files   :integer
#  pr_draft           :boolean
#  pr_merged          :boolean
#  pr_merged_at       :datetime
#  pr_review_comments :integer
#  repo_name          :string(255)
#  state              :string(255)
#  type               :string(255)
#  created_at         :datetime
#  actor_id           :string(255)
#  comment_id         :bigint
#  commit_id          :bigint
#  org_id             :bigint
#  pr_or_issue_id     :bigint
#  repo_id            :string(255)
#
# Indexes
#
#  index_github_events_on_action              (action)
#  index_github_events_on_actor_id            (actor_id)
#  index_github_events_on_actor_location      (actor_location)
#  index_github_events_on_actor_login         (actor_login)
#  index_github_events_on_additions           (additions)
#  index_github_events_on_closed_at           (closed_at)
#  index_github_events_on_comment_id          (comment_id)
#  index_github_events_on_comments            (comments)
#  index_github_events_on_commit_id           (commit_id)
#  index_github_events_on_created_at          (created_at)
#  index_github_events_on_deletions           (deletions)
#  index_github_events_on_event_day           (event_day)
#  index_github_events_on_event_month         (event_month)
#  index_github_events_on_event_year          (event_year)
#  index_github_events_on_github_staff        (github_staff)
#  index_github_events_on_is_oss_db           (is_oss_db)
#  index_github_events_on_language            (language)
#  index_github_events_on_locked              (locked)
#  index_github_events_on_milestone           (milestone)
#  index_github_events_on_number              (number)
#  index_github_events_on_org_id              (org_id)
#  index_github_events_on_org_login           (org_login)
#  index_github_events_on_pr_changed_files    (pr_changed_files)
#  index_github_events_on_pr_draft            (pr_draft)
#  index_github_events_on_pr_merged           (pr_merged)
#  index_github_events_on_pr_merged_at        (pr_merged_at)
#  index_github_events_on_pr_or_issue_id      (pr_or_issue_id)
#  index_github_events_on_pr_review_comments  (pr_review_comments)
#  index_github_events_on_repo_id             (repo_id)
#  index_github_events_on_repo_name           (repo_name)
#  index_github_events_on_state               (state)
#  index_github_events_on_type                (type)
#
require "test_helper"

class GithubEventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
