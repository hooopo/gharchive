class AddOtherField < ActiveRecord::Migration[6.1]
  def change
    add_column :github_events, :other, :json
  end
end
