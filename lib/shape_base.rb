#!/usr/bin/ruby

# file: shape_base.rb

class ShapeBase

  def initialize(scale=1)
    @shape = {}
    load_shapes()
  end

  def draw(name, properties)
    @shape[name].call(properties)
  end

  private

  def load_shapes()

  end

end

