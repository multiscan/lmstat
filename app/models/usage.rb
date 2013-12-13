class Usage < ActiveRecord::Base
  belongs_to :feature
  validates_presence_of :start_at, :on => :create, :message => "can't be blank"
  validates_presence_of :stop_at, :on => :create, :message => "can't be blank"
  validates_presence_of :used, :on => :create, :message => "can't be blank"
  validates_presence_of :total, :on => :create, :message => "can't be blank"

  before_save :precompute_values

  def self.percent_for_interval(ta, tb)
    uu=Usage.where(start_at: ta..tb).where(stop_at: ta..tb).sum(wu)

  end

  def percent
    (100*usage+0.5).to_i
  end

  def from
    start_at
  end

  def to
    stop_at
  end

  def from_ms
    self.start_at.to_i*1000
  end
  def to_ms
    self.stop_at.to_i*1000
  end
 private

  def precompute_values
    self.duration = (self.stop_at - self.start_at).to_i
    self.usage = self.used.to_f / self.total
    self.wu = self.wu = self.duration * self.usage
  end
end
