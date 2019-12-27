class F
  def initialize(is_orange)
    if is_orange
      @orange = true
    else
      @apple = true
    end
  end
end
p F.new(false).instance_variables # => [:@apple]
p F.new(true).instance_variables # => [:@orange]
p F.new(true).class
p F.class
# p Class.methods

def f(a, &block)
  throw 'No block passed' unless block_given?
  p a
  block.call
end

f(1){print 'block'}

class C
  def C.m1
  end
end
# p C.singleton_methods, C.methods, C.new.singleton_methods

c = C.new
class << c
  def s1
  end
end
# p c.singleton_methods

# require 'pp'

# pretty_inspect c