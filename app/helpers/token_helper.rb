module TokenHelper
  def token_duration(t)
    d=t.duration
    if d.blank?
      d=(Time.zone.now - t.start_at).to_i
      (d.to_s << "&nbsp;" << icon("refresh")).html_safe
    else
      d
    end
  end
end

