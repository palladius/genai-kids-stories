module ApplicationHelper
  def yellow(s)
    "\033[1;33m#{s}\033[0m"
  end

  def render_image_if_attached(model_field, _opts = {})
    # return "wrong object: #{model_field.class}" unless model_field.is_a?(ActiveStorage::Attached::One)

    verbose = _opts.fetch :verbose, false
    my_style = _opts.fetch :style, 'float:right;height:150px;'
    my_width = _opts.fetch :width, '100%' # according to docs: https://getbootstrap.com/docs/4.0/content/images/#:~:text=Images%20in%20Bootstrap%20are%20made,scales%20with%20the%20parent%20element.
    my_height = _opts.fetch :height, 'auto'
    my_class = _opts.fetch :class, 'figure-img img-fluid rounded'

    if model_field.attached?
      image_tag(model_field, style: my_style, width: my_width, height: my_height, class: my_class)
    else
      verbose ? "Sorry, #{model_field} not attached." : '-'
    end
  end

  def render_images_if_attached(_plural_model_field, _opts = {})
    # ActiveStorage::Attached::Many
    ret = "<p>#{_plural_model_field} has #{_plural_model_field.size} elements:</p>"
    _plural_model_field.attachments.each do |atch|
      # .attached? # render_image_if_attached(atch, _opts)
      ret << image_tag(atch, style: 'float:right;height:200px;') if atch
    end
    ret.html_safe
  end
end
