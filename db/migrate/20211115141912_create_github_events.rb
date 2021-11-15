class CreateGithubEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :github_events, id: false do |t|
      t.primary_key :id, :string
      t.string :type
      t.json :actor
      t.json :repo
      t.json :org
      t.json :payload
      t.boolean :public
      t.datetime :created_at
    end
  end
end
