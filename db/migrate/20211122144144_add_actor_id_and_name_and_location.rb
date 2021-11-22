class AddActorIdAndNameAndLocation < ActiveRecord::Migration[6.1]
  def change
    add_column :github_events, :actor_id, :string
    add_column :github_events, :actor_login, :string
    add_column :github_events, :actor_location, :string
  end
end
