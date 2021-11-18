class CreateImportLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :import_logs do |t|
      t.string :filename, null: false, index: true
      t.string :local_file
      t.string :imported_at
      t.string :status
      t.timestamps
    end
  end
end
