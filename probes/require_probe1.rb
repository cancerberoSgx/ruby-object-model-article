# frozen_string_literal: true

a = 123

p String.superclass
p ''.class
class String
  def trim
    strip
  end
end
p ' asd a  '.trim
# [1, 2, 3].each { |_item, i| p i }

# frozen_string_literal: true
p methods
module Module1
  p self # Module1
  p self.class # Module
  @foo = 123
  p instance_variables # [:@foo]
  def method1
    p self
    p instance_variables
    p self.class.instance_variables
  end
end

class A
  include Module1
end
a = A.new
a.method1

p 2.yield_self { |n| n * 3.14 } # prints 6.28

def name_starts_with(data, name_prefix)
  data
    .then { |persons| persons.map { |person| person[:name] } }
    .then { |names| names.select { |name| name.start_with? name_prefix } }
    .then(&:sort)
end
p name_starts_with [{ name: 'andrew' }, { name: 'laura' }], 'a'

class Array
  def some
    i = 0
    while i < length
      return self[i] if yield self[i], i

      i += 1
    end
  end
end
[1, 2, 3, 4, 5].some do |n|
  print n
  n > 2
end

# p self.methods
# require_relative 'require_probe1_stub'
# def fff
# end
# p self.methods
# p self.singleton_methods, self.instance_variables

# p instance_variables
# @foo = 123
# p instance_variables

# p self.to_s
# p to_s

# p self                    # main
# p self.instance_variables # []
# @foo = 1
# p self.instance_variables # [:foo]
# class Class1
#   p self                  # Class1
#   def method
#     p self                # #<Class1:0x00007fc66691d938>
#   end
# end

# # outside a class or module, "self" references the "main" context object
# p self.instance_variables # []
# # declaring a variable outside class or module is equivalent to
# # declare an instance variable on "self.class"
# @foo = 1
# p self.instance_variables # [:foo]

# class Class1
#   # inside a class but outside methods, "self" references the class
#   p self # Class1

#   # instance method declaration:
#   def method1
#     # inside an instance method, "self" references the instance
#     p self # #<Class1:0x00007fc66691d938>
#   end

#   # class method declaration:
#   def self.method2
#     # inside a class method, "self" references the class
#     p self # Class1
#   end
# end

# a = Class1.new
# a.method1
# Class1.method2
