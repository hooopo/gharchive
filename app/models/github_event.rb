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
#  type       :string(255)
#  created_at :datetime
#
class GithubEvent < ApplicationRecord
  self.inheritance_column = :xtype
end
