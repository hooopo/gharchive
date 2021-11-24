# == Schema Information
#
# Table name: github_events
#
#  id             :string(255)      not null, primary key
#  action         :string(255)
#  actor          :json
#  actor_location :string(255)
#  actor_login    :string(255)
#  additions      :bigint
#  body           :text(65535)
#  deletions      :bigint
#  is_oss_db      :boolean          default(FALSE)
#  language       :string(255)
#  number         :integer
#  org            :json
#  org_login      :string(255)
#  other          :json
#  payload        :json
#  public         :boolean
#  repo           :json
#  repo_name      :string(255)
#  type           :string(255)
#  created_at     :datetime
#  actor_id       :string(255)
#  comment_id     :bigint
#  commit_id      :bigint
#  org_id         :bigint
#  repo_id        :string(255)
#
# Indexes
#
#  index_github_events_on_action       (action)
#  index_github_events_on_actor_id     (actor_id)
#  index_github_events_on_actor_login  (actor_login)
#  index_github_events_on_created_at   (created_at)
#  index_github_events_on_is_oss_db    (is_oss_db)
#  index_github_events_on_language     (language)
#  index_github_events_on_repo_id      (repo_id)
#  index_github_events_on_repo_name    (repo_name)
#  index_github_events_on_type         (type)
#
class GithubEvent < ApplicationRecord
  self.inheritance_column = :xtype
end
