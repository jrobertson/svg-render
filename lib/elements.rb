#!/usr/bin/ruby

# file: elements.rb

# this code extends REXML::Document::Element
REXML::Element.class_eval do

  def ui_element=(object)
    @ui_element = object
  end
  
  def ui_element()
    @ui_element
  end

  def render()
    @ui_element.invoke
  end

  def load_ui_element

    text = self.text.to_s.strip.chomp   
    @ui_element.text = text.length > 0 ? text : ''

    # must load the parent properties
    # inherit the parent properties
    @ui_element.load_properties(self.parent.attributes)
    # get the style
    @ui_element.load_properties(self.attributes)
  end

end


