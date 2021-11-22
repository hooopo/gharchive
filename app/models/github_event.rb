# == Schema Information
#
# Table name: github_events
#
#  id         :string(255)      not null, primary key
#  actor      :json
#  is_oss_db  :boolean          default(FALSE)
#  org        :json
#  other      :json
#  payload    :json
#  public     :boolean
#  repo       :json
#  repo_name  :string(255)
#  type       :string(255)
#  created_at :datetime
#  repo_id    :string(255)
#
class GithubEvent < ApplicationRecord
  self.inheritance_column = :xtype
end
