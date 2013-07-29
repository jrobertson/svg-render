require 'svg_browser'
require 'canvas_shape'

class CanvasBrowser < Browser

  def initialize(o={})
    super(o) {|env| env.load_renderer CanvasShape::Shape.new}
  end

  def load_page(svg_file_name)
    super(svg_file_name) do |doc|
      yield(doc)
    end
  end

end

