class AddActionColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :github_events, :action, :string
  end
end
