def build_templates(t)
  a = []
  t.gsub!(/\#\{/,'\#\\{')
  t.scan(/@@ (\w+)/){ a << [$1,$']}        
  code = a.map {|x| i = x[1] =~ /@@/; r = i.nil? ? x[1] : x[1][0,i] ; [x[0], r] }
  template_code = code.map {|f,c| "@@templates[:%s] = \"%s\"" % [f, c.gsub(/"/,'\\"')]}
  instance_eval(template_code.join("\n"))
  instance_eval("template :layout do \"%s\" end" % @@templates[:layout].strip) if @@templates.has_key? :layout
end

