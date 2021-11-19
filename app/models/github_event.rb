# == Schema Information
#
# Table name: github_events
#
#  id         :string(255)      not null, primary key
#  actor      :json
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
