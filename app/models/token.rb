class Token < ActiveRecord::Base
  belongs_to :feature, :class_name => "Feature", :foreign_key => "feature_id"
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :workstation, :class_name => "Workstation", :foreign_key => "workstation_id"

  before_create :assign_slot
  # before_create :add_to_feature

  scope :open, -> { where(stop_at: nil) }
  scope :closed, -> { where.not(stop_at: nil) }
  scope :open_at, ->(t) { where(['start_at <= ? AND (stop_at > ? OR stop_at IS NULL)', t, t]) }
  scope :open_between, ->(ta, tb) { where(['(start_at >= ? AND start_at < ?) OR (start_at < ? AND ( stop_at > ? OR stop_at IS NULL) )', ta, tb, ta, ta]) }
  def username=(s)
    u=User.find_or_create_by(uid: s)
    self.user = u
  end

  def hostname=(s)
    w=Workstation.find_or_create_by(hostname: s)
    self.workstation = w
  end

  # close the token and update the corresponding feature
  def close(now=Time.zone.now)
    # puts "close: now=#{now}   start_at=#{self.start_at}   duration=#{(now-self.start_at).to_i}"
    update_attributes(stop_at: now, duration: (now-self.start_at).to_i)
  end

  def start_ms
    self.start_at.to_i * 1000
  end

  def stop_ms
    (self.stop_at || Time.zone.now).to_i * 1000
  end

  def self.find_all_active_at_time(t, f=nil)
    if f
      where("feature_id = ? AND start_at <= ? AND ( stop_at = ? OR stop_at > ?)", f.id, t, nil, t)
    else
      where("start_at <= ? AND ( stop_at = ? OR stop_at > ?)", t, nil, t)
    end
  end

  def color
    self.feature.color
  end

 private

  # find a free slot for this token
  def assign_slot
    used_slots=Token.where(feature_id: self.feature_id).where(['start_at >= ? OR stop_at > ? OR stop_at IS NULL', self.start_at, self.start_at]).map{|t| t.slot}.sort
    if used_slots.empty?
      self.slot = 0
    else
      last=used_slots.last+1
      self.slot = ((0..last).to_a - used_slots).first
    end
  end

  # def add_to_feature
  #   puts "Token.add_to_feature: f=#{self.feature}"
  #   self.feature.increment_used
  # end
end
