require 'pathname'

log_dir = ENV["LMSTAT_LOG_DIR"] ? Pathname.new(ENV["LMSTAT_LOG_DIR"]) : Rails.root.join("db", "seed_data", "logs")
puts "Importing log files from #{log_dir}"
done_dir=log_dir.join("done")
Dir.glob(log_dir.join("*.log")) do |log_file|
  s=LmStatus.new(logpath: log_file)
  if s.save
    FileUtils.mv(log_file, done_dir)
  else
    raise "Failed to load log file #{log_file}"
  end
end

