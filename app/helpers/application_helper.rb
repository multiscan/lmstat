module ApplicationHelper

  def time_fmt(t)
    time_tag t, t.strftime('%Y-%m-%d %H:%M')
  end

  def date_fmt(t)
    time_tag t, t.strftime('%Y-%m-%d')
  end

  def period(ti)
    if ti.dt > 86400
      "Period from #{date_fmt ti.ta} to #{date_fmt ti.tb} (#{distance_of_time_in_words ti.ta, ti.tb} interval).".html_safe
    else
      "Period from #{time_fmt ti.ta} to #{time_fmt ti.tb} (#{distance_of_time_in_words ti.ta, ti.tb} interval).".html_safe
    end
  end

  def yesno_label(b)
    (b ? "<span class='label label-success'>Yes</span>" : "<span class='label label-danger'>No</span>").html_safe
  end
  def noyes_label(b)
    (b ? "<span class='label label-danger'>Yes</span>" : "<span class='label label-success'>No</span>").html_safe
  end
  def with_label(t, l="success")
    "<span class='label label-#{l}'>#{h t}</span>".html_safe
  end
  def icon_with_text(i,t)
    "<i class='glyphicon glyphicon-#{i}'></i>&nbsp;#{h t}".html_safe
  end
  def text_with_icon(i,t)
    "#{h t}&nbsp;<i class='glyphicon glyphicon-#{i}'></i>".html_safe
  end
  def icon(i)
    "<i class='glyphicon glyphicon-#{i}'></i>".html_safe
  end
  def edit_with_icon(t="Edit")
    icon_with_text("edit", t)
  end
  def show_with_icon(t="More...")
    icon_with_text("zoom-in", t)
  end
  def index_with_icon(t="List")
    icon_with_text("list", t)
  end
  def add_with_icon(t="Add")
    icon_with_text("plus", t)
  end

  def might_paginate(v, opts)
    all_opts = {:renderer => BootstrapPagination::Rails}.merge(opts)
    will_paginate v, all_opts if v.respond_to?(:total_pages)
  end

end
