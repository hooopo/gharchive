class AddIsOssDbColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :github_events, :is_oss_db, :boolean, default: false
  end
end
