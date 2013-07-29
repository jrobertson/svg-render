def render_canvas(template_name)
  url = "http://rorbuilder.info/r/heroku/erb/canvas.erb"
  t = open(url, "UserAgent" => "Sinatra-Rscript").read
  build_templates(t)

  @@templates[template_name] = yield.strip
  @content_type = 'text/xml'
  erb @@templates[template_name]
end      



