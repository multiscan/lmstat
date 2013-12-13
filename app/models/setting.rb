class Setting < ActiveRecord::Base
  serialize :value
  def self.set(key, value)
    s=find_or_create_by_key(key)
    s.value=value
    s.save
  end
  def self.get(key)
    find_last_by_key(key).value
  end
end
