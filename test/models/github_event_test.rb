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
require "test_helper"

class GithubEventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
