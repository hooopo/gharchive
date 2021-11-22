class AddLanguageColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :github_events, :language, :string
  end
end
