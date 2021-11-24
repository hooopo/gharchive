class AddOrgIdAndOrgLogin < ActiveRecord::Migration[6.1]
  def change
    add_column :github_events, :org_login, :string, index: true
    add_column :github_events, :org_id, :bigint, index: true
  end
end
