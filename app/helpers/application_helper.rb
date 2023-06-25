module ApplicationHelper
  def yellow(s)
    "\033[1;33m#{s}\033[0m"
  end

  def render_image_if_attached(model_field)
    if model_field.attached?
      image_tag(model_field, style: 'float:right;height:200px;')
    else
      "Sorry, #{model_field} not attached."
    end
  end
end
