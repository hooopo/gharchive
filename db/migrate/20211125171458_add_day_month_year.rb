class AddDayMonthYear < ActiveRecord::Migration[6.1]
  def change
    add_column :github_events, :event_day, :string
    add_column :github_events, :event_month, :string
    add_column :github_events, :event_year, :integer
  end
end
