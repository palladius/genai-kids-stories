module ApplicationHelper
  def yellow(s)
    "\033[1;33m#{s}\033[0m"
  end

  def render_image_if_attached(model_field, _opts = {})
    verbose = _opts.fetch :verbose, true
    my_style = _opts.fetch :style, 'float:right;height:200px;'
    my_width = _opts.fetch :width, nil
    if model_field.attached?
      image_tag(model_field, style: my_style, width: my_width)
    else
      verbose ? "Sorry, #{model_field} not attached." : ''
    end
  end
end
