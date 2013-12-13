# curl -H "Content-Type: application/json" -d '{"a":1, "b":2}' -i -X POST localhost:3000/lmlogs.json
desc "Send lmstat output to server"
task :lmstat => [:environment] do
  dd=Rails.root.join("db", "seed_data", "done")
  Dir.glob(Rails.root.join("db", "seed_data", "logs", "*.log")) do |f|
    base=File.basename(f, ".log")
    p=LmstatParser.new(f)
    resp=RestClient.post "http://localhost:3000/lm.json", {time: base, features: p.features}.to_json, :content_type => :json, :accept => :json
    FileUtils.mv(f, dd) if resp.code == 200
  end
end
