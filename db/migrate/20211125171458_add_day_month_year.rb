class AddDayMonthYear < ActiveRecord::Migration[6.1]
  def change
    add_column :github_events, :event_day, :string, index: true
    add_column :github_events, :event_month, :string, index: true
    add_column :github_events, :event_year, :integer, index: true
  end
end
