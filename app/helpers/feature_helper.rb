module FeatureHelper
  def colorbox(c)
    "<div class='colorbox' style='background-color: #{h(c)}'>&nbsp;</div>".html_safe
  end
end
