#!/usr/bin/ruby

# file: canvas_shape.rb

require 'shape_base'

module CanvasShape

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

        Proc.new do 
          puts "*** drawing a line"
"
ctx.strokeStyle = '#{colour}';
ctx.lineWidth = #{stroke_width};
ctx.beginPath();
ctx.moveTo(#{x1},#{y1});
ctx.lineTo(#{x2},#{y2});
ctx.stroke();"
      
        end
      end

      rectangle = Proc.new do |h|
        x, y = h[:x], h[:y]
        width, height=  h[:width], h[:height]
        
        style = h[:style]
        fill = style[:fill]        
        stroke = style[:stroke]
        stroke_width = style['stroke-width']

        Proc.new do 
          puts "*** drawing a rectangle"
          
<<CANVAS
       
ctx.fillStyle = "#{fill}";
ctx.fillRect (#{x}, #{y}, #{width}, #{height});

CANVAS
          
          #canvas.rect(x2, y2, x1, y1).styles(:fill => fill, :stroke => stroke, :stroke_width => stroke_width)
        end
      end


      text = lambda do |h|
        x, y = h[:x], h[:y]
        font_size = h[:font][:size] # ???
        fill = h[:style][:fill]
        text2 = h[:text]
        text_align = h[:style][:text_align]

        #jr031209 stroke = h[:stroke]
        #jr031209 r,g,b = stroke[:rgb]

        return Proc.new {} if text2.length < 1
        Proc.new do 
          puts "*** drawing text x %s y %s text: %s" % [x,y,text2]
<<CANVAS

ctx.font = "#{font_size}em Times New Roman";
ctx.fillStyle = "#{fill}";
ctx.textAlign = '#{text_align}';
ctx.fillText("#{text2}", #{x}, #{y});

CANVAS
        end
      end

      @shape[:line] = line
      @shape[:rectangle] = rectangle
      @shape[:text] = text

    end
  end

end
