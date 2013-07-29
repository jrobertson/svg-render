require 'render_svg3'
require 'rcscript'

class Browser

  attr_accessor :doc

  def initialize(o={})
    
    h = {scale:0.5, x_offset:0, y_offset:0}.merge o
    svg_environ = ElementSvg.new
    yield(svg_environ)
    
    svg_environ.scale = h[:scale]
    svg_environ.x_offset = h[:x_offset] 
    svg_environ.y_offset = h[:y_offset]

    @svg_engine, @script = RenderSvg.new(), RScriptBase.new()
    
  end

  def load_page(url)
    #url = 'http://rorbuilder.info/r/heroku/image/' + svg_file_name
    buffer = open(url, 'UserAgent' => 'Sinatra-Rscript').read
    #puts 'buffer : ' + buffer
    doc = Document.new(buffer)
    yield(doc) if block_given?
    #puts '@doc : ' + @doc.to_s
    script = @script.run(doc)
    #eval(script) # de-activated for now
    @svg_engine.render doc
    @svg_engine.svg_procs
  end

end

