#!/usr/bin/ruby

# file: rvg_shape.rb

require 'shape_base'

module RVGShape

  class Shape < ShapeBase
    
    def initialize()
      super
    end

    private

    def load_shapes()

      line =  Proc.new do |h|
        x1, y1, x2, y2 = h[:x1], h[:y1], h[:x2], h[:y2]
        #x2, y2 = (h[:width] - x1), (h[:height] - y1)
        stroke = h[:stroke]
        stroke_width = stroke[:width]
        colour = stroke[:colour]

        Proc.new do |canvas|
          puts "*** drawing a line"
          canvas.line(x1, y1, x2, y2).styles(:stroke=> "#{colour}" , :stroke_width => stroke_width)
        end
        
      end

      rectangle = Proc.new do |h|
        x, y = h[:x], h[:y]
        width, height = h[:width], h[:height]
        
        style = h[:style]
        fill = style[:fill]        
        stroke = style[:stroke]
        stroke_width = style['stroke-width']

        Proc.new do |canvas|
          puts "*** drawing a rectangle x: %s y: %s" % [x, y]
          canvas.rect(width, height, x, y).styles(:fill => fill, :stroke => stroke, :stroke_width => stroke_width)
        end
      end


      text = lambda do |h|

        x, y = h[:x], h[:y]
        font_size = (h[:font][:size] * 16) # ???
        fill = h[:style][:fill]
        text2 = h[:text]
        text_align = h[:style][:text_align]

        #jr031209 stroke = h[:stroke]
        #jr031209 r,g,b = stroke[:rgb]
        return Proc.new {} if text2.length < 1

        Proc.new do |canvas|
          puts "*** drawing text x: %s y: %s" % [x, y]
          canvas.text(x, y, text2).styles(:text_anchor => text_align, :font_size=> font_size, :font_family=>'helvetica', :fill => fill)
        end

      end

      @shape[:line] = line
      @shape[:rectangle] = rectangle
      @shape[:text] = text

    end
  end

end
