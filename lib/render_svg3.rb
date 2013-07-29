#!/usr/bin/ruby
# file: render_svg3.rb

require 'elements'

class SvgEnvironment

  def initialize()
    @@scale = 0.5
  end
  
  def load_renderer(renderer)
    @@shape2 = renderer
  end
  
  def scale()
    @@scale
  end
  
  def scale=(val)
    @@scale = val
  end
end

class ElementSvg #< SvgEnvironment
#include RVGShape

  # this initialize method should be overridden with a class_eval from the calling RSF job
  def initialize()
    initialize_variables()
    #@@shape = RVGShape::Shape.new
    #@@shape = Shape.new
  end
    
  def initialize_variables()
    @property = {'style' => ''}
    @style_property = {}    
  end

  def text=(val)
    @text = val
  end

  def text()
    @text
  end

  def scale=(val);    @@scale = val;  end
  def scale()    @@scale  end
  
  def x_offset=(val);    @@x_offset = val;  end
  def x_offset();    @@x_offset;  end
    
  def y_offset=(val);    @@y_offset = val;  end
  def y_offset();    @@y_offset;  end    

  def render_element()
    #parse_style()
    properties = yield
    @@shape.draw @type, properties
  end

  def parse_style()
    if @property['style'] then
      properties = get_style_properties(@property['style']) 

      #h = Hash[*properties.join(';').split(';')]
      properties.each do |name, value|
        @style_property[name] = value if @style_property.has_key? name
      end

    end
  end

  def get_style_properties(properties_string)
    properties_string.split(/;/).map do |a|
      a.match(/^(.[^:]+):([^$]+$)/).captures.map {|x| x.strip}
    end
  end

  def load_properties(attributes)
    attributes.each_attribute do |attribute|
      @property[attribute.name] = attribute.value if @property.has_key? attribute.name
    end
    parse_style()
  end
  
  def load_renderer(renderer)
    @@shape = renderer
  end
end

class ElementEllipse < ElementSvg
  def initialize()
    super
  end

  def invoke()
    puts " -- render the 'ellipse' element"    
    render_element()
  end
end


class ElementRect < ElementSvg

  def initialize()
    super
    local_properties = {'x' => '','y' => '', 'width' => '', 'height' => ''}
    @property.merge!(local_properties)
    @style_property = {'fill' => '', 'stroke' => '', 'stroke-width' => ''}
    @type = :rectangle
  end

  def invoke()
    puts " -- render the 'rect' element" 
    render_element()
  end

  def render_element()
    super do 
      h = @property; hs = @style_property
      x1, y1, x2, y2 =  h['x'].to_i,  h['y'].to_i,  h['x'].to_i + h['width'].to_i,  h['y'].to_i + h['height'].to_i
      #r,g,b = hs['fill'].match(/rgb\((\d{1,5}),(\d{1,5}),(\d{1,5})\)/).captures
      style =  {:fill => hs['fill'], :stroke => hs['stroke'], :stroke_width => hs['stroke-width']}
      
      #scale = run_projectx('registry', 'get-key', :path => 'app/svg_viewer/scale').first.to_f
      x1, y1, x2, y2 = [x1, y1, x2, y2].map {|x| x * @@scale}
      x1, x2 = [x1, x2].map {|x| x + @@x_offset * @@scale}
      y1, y2 = [y1, y2].map {|x| x + @@y_offset * @@scale}

      properties = {:x => x1, :y => y1, :width => x2 - x1, :height => y2 - y1, :style => style}
      #properties = {:x => x1, :y => y1,  :width => x2 - x1, :height => y2 - y1}
      #draw properties
    end
  end

end


class ElementLine < ElementSvg

  def initialize()
    super
    local_properties = {'x1' => '','y1' => '', 'x2' => '', 'y2' => ''}
    @property.merge!(local_properties)
    @style_property = {'stroke' => '', 'stroke-width' => ''}
    @type = :line
  end

  def invoke()
    puts " -- render the 'line' element "  + @text
    render_element() 
  end

  def render_element()
    super do
      h = @property; hs = @style_property
      x1, y1, x2, y2 =  h['x1'].to_i,  h['y1'].to_i,  h['x2'].to_i,  h['y2'].to_i
      stroke_width = hs['stroke-width'].to_i
      colour = hs['stroke']

      #scale = run_projectx('registry', 'get-key', :path => 'app/svg_viewer/scale').first.to_f
      x1, y1, x2, y2 = [x1, y1, x2, y2].map {|x| x * @@scale}
      x1, x2 = [x1, x2].map {|x| x + @@x_offset * @@scale}
      y1, y2 = [y1, y2].map {|x| x + @@y_offset * @@scale}
      
      stroke = {:width => stroke_width, :colour => colour}
      {:x1 => x1, :y1 => y1, :x2 => x2, :y2 => y2, :stroke => stroke}
      #draw properties
    end
  end

end

class ElementText < ElementSvg
  def initialize()
    super
    local_properties = {'x' => '','y' => '', 'fill' => '', 'font-size' => '15'}
    @property.merge!(local_properties)
    @style_property = {'font-size' => '', 'font-style' => '', 'font-weight' => '', 
                       'fill' => '', 'fill-opacity' => '', 'stroke' => '', 'font-family' => '', 'text-align' => 'start'}
    @type = :text
  end

  def invoke()
    puts " -- render the 'text' element" 
    render_element()
  end

  def render_element()
    super do
      h = @property; style = @style_property
      style.delete_if {|key, value| value.empty?}
      h.merge! style
      x, y =  h['x'].to_i,  h['y'].to_i
      font_size = (h['font-size'].to_f * 0.0625) unless h['font-size'].empty?

      
      fill = h['fill']
      text2 = self.text
      text_align = h['text-align'] 
      @style_property['text-align'] = 'start'
      #@style_property = {'font-size' => '', 'font-style' => '', 'font-weight' => '', 
       #                'fill' => '', 'fill-opacity' => '', 'stroke' => '', 'font-family' => '', 'text-align' => 'start'}
      #puts 'xzx ' + text2 + 'xzx'
     
      #stroke_width = hs['stroke-width'].to_i
      #r,g,b = hs['stroke'].match(/rgb\((\d{1,5}),(\d{1,5}),(\d{1,5})\)/).captures
      #puts 'x0xx ' + font_size.to_s + ' y0yy'
      #scale = run_projectx('registry', 'get-key', :path => 'app/svg_viewer/scale').first.to_f
      x, y, font_size = [x, y, font_size].map {|x| x * @@scale }
      #x_offset = -40
      x += @@x_offset * @@scale
      y += @@y_offset * @@scale
      #puts 'x1xx ' + font_size.to_s + ' y1yy'

      {:x => x, :y => y, :text => text2, :style => {:fill => fill, :text_align => text_align}, :font => {:size => font_size}}
    end
  end

end


class RenderSvg
  def initialize()
    @dom = {}
    @svg_procs = []
    puts 'render ...'

    load_elements
    #@dom = render_document(doc.root)    
  end

  def load_elements()
    @h = {}
    @h['ellipse'] = ElementEllipse.new
    @h['line'] = ElementLine.new
    @h['rect'] = ElementRect.new
    @h['text'] = ElementText.new
    @h['tspan'] = ElementText.new

  end

  def render(doc)
    @svg_procs = []
    render_all doc        
  end

  def render_all( doc)
    if @h.has_key? doc.name then
      doc.ui_element = @h[doc.name] 
      doc.load_ui_element
      @svg_procs << doc.ui_element.invoke
    end

    doc.elements.each { |node|  render_all node}
  end

  def svg_procs()
    @svg_procs
  end

end

