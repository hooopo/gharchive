# == Schema Information
#
# Table name: import_logs
#
#  id                :bigint           not null, primary key
#  end_download_at   :datetime
#  end_import_at     :datetime
#  filename          :string(255)      not null
#  local_file        :string(255)
#  start_batch_at    :datetime
#  start_download_at :datetime
#  start_import_at   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_import_logs_on_filename  (filename)
#
class ImportLog < ApplicationRecord
  def self.download(start_batch_at, filename)
    return unless block_given?
    log = self.create!(start_batch_at: start_batch_at, filename: filename, start_download_at: Time.now)
    yield(log)
    log.update(end_download_at: Time.now)
    log
  end

  def self.import(filename, log)
    return unless block_given?
    log.update(start_import_at: Time.now)
    yield(log)
    log.update(end_import_at: Time.now)
  end
end
