module ApplicationHelper
  def render_if(condition, record)
    if condition
      render record
    end
  end

  def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes['style'] = "display: none"
    end
    content_tag("div", attributes, &block)
  end
end
