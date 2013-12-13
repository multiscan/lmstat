class TimeInterval
  attr_reader :ta, :tb, :t, :dt

  # This is called with TimeInterval.new(params.permit([:t, :ta, :tb, :dt]))
  def initialize(p={})
    Rails.logger.debug("Initializing TimeInterval with #{p.inspect}")
    d = a = c = b = nil
    d = p[:dt].to_i.seconds if p[:dt].present?
    c = to_time(p[:t])  if p[:t].present?
    a = to_time(p[:ta]) if p[:ta].present?
    b = to_time(p[:tb]) if p[:tb].present?

    @given = !(d.nil? && a.nil? && c.nil? && b.nil?)

    if (a.nil? || b.nil?)
      if a && d
        b = a + d
      elsif b && d
        a = b - d
      elsif c && d
        a = c - d/2
        b = c + d/2
      elsif c && a
        b ||= c + (c - a)
      elsif c && b
        a ||= c - (b - c)
      elsif c
        d = 1.day
        a = c - d/2
        b = a + d
      else
        d ||= 1.day
        b ||= Time.zone.now
        a ||= b - d
      end
    end
    d ||= b - a
    c ||= a + d/2

    @ta = a
    @tb = b
    @t  = c
    @dt = d
    Rails.logger.debug("Initialized TimeInterval: ta=#{ta} - t=#{t} - tb=#{tb} / dt=#{dt} - given?=#{@given}")
  end


  def next
    TimeInterval.new(dt: @dt, t: @t+@dt)
  end

  def prev
    TimeInterval.new(dt: @dt, t: @t-@dt)
  end

  def query_hash
    {t: @t, dt: @dt}
  end

  def to_query
    query_hash.to_query
  end

  def given?
    @given
  end

  def dt_ms
    @dt * 1000
  end

  def ta_ms
    to_ms(@ta)
  end

  def tb_ms
    to_ms(@tb)
  end

  def t_ms
    to_ms(@t)
  end

 private
  def to_ms(v)
    v.to_i * 1000
  end

  def to_time(p)
    return p if p.is_a? Time
    begin
      t=Time.parse(p)
    rescue
      t=nil
    end
    t
  end

end
