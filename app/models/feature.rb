class Feature < ActiveRecord::Base

  COLORS = [
    '#2f7ed8', '#0d233a', '#8bbc21', '#910000', '#1aadce', '#492970', '#f28f43', '#77a1e5', '#c42525', '#a6c96a',
    '#003399', '#993300', '#006633',
    # '#ff9933', '#996633', '#3399ff',
    '#9900cc', '#ff6600', '#339933',
    '#ff0000', '#0000ff', '#00ff00'
  ]
  NCOLOR=COLORS.length

  has_many :usages
  has_many :tokens

  validates_presence_of :total, :on => :create, :message => "can't be blank"

  scope :by_used, -> { order("used DESC").order(:id) }

  # TODO: sanity check and return false if not valid!!!
  def self.import(fh, now=Time.zone.now)
    f=Feature.create_with(used: fh[:used], total: fh[:total], since: now, last_seen_at: now).find_or_create_by(name: fh[:name])
    f.update_usage(fh[:used], fh[:total], now)
    tk=fh[:tokens]
    f.update_tokens(tk, now) if tk.present?
    true
  end

  def update_usage(u, t, now=Time.zone.now)
    if u != self.used || t != self.total
      self.usages.create(used: self.used, total: self.total, start_at: self.since, stop_at: now)
      self.update_attributes(used: u, total: t, since: now, last_seen_at: now)
    else
      self.touch(now)
      nil
    end
  end

  def update_tokens(tthh, now=Time.zone.now)
    ot = tthh.map do |th|
      self.tokens.open.where(signature: th[:signature]).first                 ||
        self.tokens.create(signature: th[:signature], start_at: th[:start],
                           username: th[:username], hostname: th[:hostname],
                           pid: th[:pid], count: th[:count])
    end
    ct = self.tokens.open - ot
    if ct.size>0
      ct.each { |t| t.close(now) }
    end
  end

  def to_s
    "feature #{self.name}: used=#{self.used} total=#{self.total}"
  end

  def percent
    100*used/total
  end

  def shortname(len=32)
    self.nick || self.name.truncate(len)
  end

  def next
    Feature.where("id > ?",self.id).where(:visible => true).order("id ASC").first
  end

  def prev
    Feature.where("id < ?",self.id).where(:visible => true).order("id ASC").last
  end

  def usage
    used.to_f / total
  end

  def last_seen_ms
    self.last_seen_at.to_i*1000
  end

  def touch(now=Time.zone.now)
    self.update_attribute(:updated_at, now) if self.updated_at < now-1.day
  end

  def color
    # self.custom_color || Feature::COLORS[self.id%Feature::NCOLORS]
    Feature::COLORS[(self.id-1)%Feature::NCOLOR]
  end

end
