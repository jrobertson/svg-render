require 'svg_browser'
require 'canvas_shape'
require 'rvg_shape'

module SVG
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

  class RVGBrowser < Browser

    def initialize(o={})
      super(o) {|env| env.load_renderer RVGShape::Shape.new}
    end

    def load_page(svg_file_name)
      super(svg_file_name) do |doc|
	yield(doc)
      end
    end

  end
end