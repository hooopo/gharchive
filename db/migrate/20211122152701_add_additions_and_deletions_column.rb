class AddAdditionsAndDeletionsColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :github_events, :additions, :bigint
    add_column :github_events, :deletions, :bigint
  end
end
