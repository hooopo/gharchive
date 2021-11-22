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
#  deletions      :bigint
#  is_oss_db      :boolean          default(FALSE)
#  language       :string(255)
#  org            :json
#  other          :json
#  payload        :json
#  public         :boolean
#  repo           :json
#  repo_name      :string(255)
#  type           :string(255)
#  created_at     :datetime
#  actor_id       :string(255)
#  repo_id        :string(255)
#
require "test_helper"

class GithubEventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
