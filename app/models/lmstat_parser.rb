# ------------------------------------------------------------------------------
# Feature line:
# -------------
# Users of 111:  (Total of 16 licenses issued;  Total of 7 licenses in use)
# Users of Phys_Ver_Sys_DRC_XL:  (Total of 1 license issued;  Total of 0 licenses in use)
# Users of Allegro_Design_Publisher:  (Total of 1 license issued;  Total of 0 licenses in use)
# ------------------------------------------------------------------------------
# Used Token line:
# ----------------
# cronie app0.landou :1050.0 (v6.150) (app0/5280 124), start Mon 1/23 9:07
# hugo app6.landou ws0.landou:0 APS Base (v12.100) (lm.landou/5280 1320), start Mon 11/25 15:27, 2 licenses
# First split on ", " and then use 3 different RE:
# TOKEN_RE1: hugo app6.landou ws0.landou:0 APS Base (v12.100) (lm.landou/5280 1320)
# TOKEN_RE2: start Mon 11/25 15:27
# TOKEN_RE3: 2 licenses
class LmstatParser
  FEATURE_RE=%r{^Users of ([^:]*):[^0-9]*([0-9]+)[^0-9]*([0-9]+)}
  TOKEN_RE1=%r{\s*([^\s]*)\s+([^\s]*)\s+([^\s]*)\s+(.*)\s+\(([a-z0-9.]+)/([0-9]+)\s+([0-9]+)\)}
  # TOKEN_RE2=%r{.*\s+([0-9/]*)\s+([0-9:]*).*}
  TOKEN_RE2=%r{.*\s+([0-9/]+\s+[0-9:]+).*}
  TOKEN_RE3=%r{\s*([0-9]*).*}

  def initialize(source)
    file = if source.nil?
             # return an open pipe to lmstat command
           else
             File.new(source, "r")
           end
    @features = []
    parse_lmstat_file(file)
    file.close
  end

  def features
    @features
  end

 private

  def parse_lmstat_file(file)
    while (line = file.gets)
      m = FEATURE_RE.match(line)
      if m && m.size>0
        name, total, used = m[1], m[2].to_i, m[3].to_i
        feature = {name: name, total: total, used: used, tokens: []}
        Rails.logger.debug "    feature: #{name} : #{used}/#{total}"
        if used > 0
          tokens=[]
          4.times{file.gets}                                      # skip 4 lines
          nt=used
          while(nt>0)
            line = file.gets.chomp
            next if line =~ / queued for [0-9]+ license/
            t = parse_lmstat_token_line(line)
            tokens << t
            nt = nt - t[:count]
          end
          feature[:tokens] = tokens
        end
        @features << feature
      end
    end
  end

  def parse_lmstat_token_line(line)
    s=line.strip
    p1,p2,p3=s.split(", ")
    mp1=TOKEN_RE1.match(p1)
    mp2=TOKEN_RE2.match(p2)
    if mp1.nil? || mp2.nil?
      puts "Invalid token line: -->#{line}<--"
      raise "Invalid lmstat line for token"
    end

    # irb(main):059:0> p1
    # => "    hugo app6.landou ws0.landou:0 APS Base (v12.100) (lm.landou/5280 1320)"
    # irb(main):060:0> TOKEN_RE1.match(p1)
    # => #<MatchData "    hugo app6.landou ws0.landou:0 APS Base (v12.100) (lm.landou/5280 1320)" 1:"hugo" 2:"app6.landou" 3:"ws0.landou:0" 4:"APS Base (v12.100)" 5:"lm.landou" 6:"5280" 7:"1320">
    # irb(main):061:0> p2
    # => "start Mon 11/25 15:27"
    # irb(main):062:0> TOKEN_RE2.match(p2)
    # => #<MatchData "start Mon 11/25 15:27" 1:"11/25 15:27">

    username, ws_run, ws_ui, desc, lic_server, port, pid = mp1[1..7]
    start = DateTime.strptime(mp2[1], "%m/%d %H:%M") - ENV['TIMEZONE'].to_i.hours
    count = 1
    unless p3.nil?
      mp3=TOKEN_RE3.match(p3)
      count = mp3[1].to_i if mp3
    end
    signature = Rails.env.production? ? Digest::SHA1.hexdigest(s) : s
    {signature: signature, username: username, hostname: ws_run, pid: pid.to_i, start: start, count: count}
  end

end

  # def parse_lmstat_file(file)
  #   while (line = file.gets)
  #     Rails.logger.debug("\n\n #{line}")
  #     m = PARSE_FEATURE_RE.match(line)
  #     if m && m.size>0
  #       name, total, used = m[1], m[2].to_i, m[3].to_i
  #       Rails.logger.debug "    feature: #{name} : #{used}/#{total}"

  #       f=Feature.find_or_initialize(name: name)
  #       f.update_usage(used, total, now)
  #       if used > 0
  #         # skip 4 lines
  #         # file.lineno = file.lineno + 4
  #         4.times{file.gets}
  #         # read and parse the token lines
  #         still_open=Array.new
  #         used.times do
  #           line = file.gets.chomp
  #           Rails.logger.debug("\n\n #{line}")
  #           still_open << parse_lmstat_token_line(line, f)
  #         end
  #         f.update_tokens(still_open)
  #       end
  #     end
  #   end
  #   # check consistency
  #   Feature.all.each do |f|
  #     used=f.open_tokens.count
  #     raise "Inconsistent used count: f.used=#{f.used} used=#{used}" if f.used != used
  #   end
  # end

  # def parse_lmstat_token_line(s, f)
  #  hs = Rails.env.production? ? Digest::SHA1.hexdigest(s) : s
  #  t=f.tokens.find_by_uid(hs)
  #  Rails.logger.debug "       old token: #{t.user.uid}@#{t.workstation.hostname}  start=#{t.start}  h=#{t.handle} uid=#{t.uid}" if t
  #  return t if t
  #  p=PARSE_TOKEN_RE.match(s)
  #  # Rails.logger.debug "match: len=#{p.length} - #{p.inspect}"
  #  # trigger exception instead of returning nil!
  #  return nil unless p && p.length==9

  #  # 1:"cronie" 2:"app0.landou" 3:":1050.0" 4:"app0" 5:"5280" 6:"521" 7:"1/22" 8:"18:05">
  #  uid, ws_run, ws_co, lic_server, port, handle, ddd, ttt = p[1..9]
  #  start=DateTime.strptime("#{ddd} #{ttt}", "%m/%d %H:%M")
  #  user=User.find_or_create_by(uid: uid)
  #  workstation=Workstation.find_or_create_by(hostname: ws_run)
  #  t=f.tokens.create(
  #                  :user_id        => user.id,
  #                  :workstation_id => workstation.id,
  #                  :handle         => handle.to_i,
  #                  :uid            => hs,
  #                  :start          => start,
  #                  :stop           => nil
  #                )
  #  Rails.logger.debug "       new token: #{t.user.uid}@#{t.workstation.hostname}  start=#{t.start}  h=#{t.handle} uid=#{t.uid}"
  #  return t
  # end

