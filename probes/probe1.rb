class MyHash < BasicObject
  def initialize
    @data = {}
  end
  def method_missing(method, *args)
    name = method.to_s
    if name.end_with? '='
      @data[name.slice(0, name.length - 1)] = args[0]
    else
      @data[name]
    end
  end
end
hash = MyHash.new
hash.display = 'hello'
p hash.display  # => hello
# p hash.foo # => 1

# class MyClass
#   def method_missing(method, *args)
#     p "You called: #{method}(#{args.join(', ')})"
#     p "(You also passed it a block)" if block_given?
#   end
# end
# obj = MyClass.new
# obj.non_existent_method('a', 3.14) { }

# module M
#   class C
#     module M2
#       p Module.nesting   # => [M::C::M2, M::C, M]
#       p Module.constants # => [:M2, :C, a lot more...
#     end
#   end
# end

# X = 'constant 1'
# module M
#   X = 'constant 2'
#   class C
#     X = 'constant 3'
#     p ::X         # => constant 1
#     p ::M::C::X   # => constant 3
#   end
# end
# p X               # => constant 1
# p M::X            # => constant 2
# p M::C::X         # => constant 3

# # frozen_string_literal: true
# class MyClass
#   def method1; end
# end
# obj = MyClass.new
# def obj.method2; end

# p obj.singleton_class
# p obj.class

# class ComplexNumber
#   attr_reader :real, :imaginary
#   def initialize(real = 0, imaginary = 0)
#     @real = real
#     @imaginary = imaginary
#   end
#   def +(other)
#     ComplexNumber.new @real + other.real, @imaginary + other.imaginary
#   end
#   def to_s
#     "ComplexNumber(#{@real}, #{@imaginary})"
#   end
# end

# a = ComplexNumber.new(1, 1)
# b = ComplexNumber.new(2, 2)
# print a + b # => ComplexNumber(3, 3)

# class Base
#   def self.second(*methods)
#     methods.each{|method|
#     define_method("#{method}2") do |*args, &block|
#       print "'#{method}' called"
#       send method, *args, &block
#     end
#   }
#   end
# end
# class Elf < Base
#   second :foo
#   def foo; end
# end
# elf = Elf.new
# elf.foo
# elf.foo2 # => 'method' called

# # class MyBaseClass
# # end
# # class MyClass < MyBaseClass
# # end
# # obj1 = MyClass.new
# # p obj1.class # => MyClass
# # p MyClass.superclass # => MyBaseClass
# # p MyClass.class.superclass # => Module
# # p MyClass.class.superclass.superclass # => Object

# # # class A
# # # end
# # # a=A.new
# # # p a.methods
# # # p A.singleton_methods
# # # p a.singleton_methods

# # # module StringUtil
# # #   refine String do
# # #     def reverse
# # #       "REVERSED"
# # #     end
# # #   end
# # # end
# # # module IsolatedCode
# # #   using StringUtil
# # #   p 'hello'.reverse  # "REVERSED"
# # # end
# # # p 'hello'.reverse    # "olleh"

# # # # class Blank < BasicObject
# # # #   def foo
# # # #     'foo'
# # # #   end
# # # # end
# # # # b = Blank.new
# # # # p b.equal? b

# # # # # p BasicObject.instance_methods
# # # # # p BasicObject.class.instance_methods

# # # # class Node
# # # #   @@default_style = {bg: 'blue', fg: 'white'}
# # # #   def render(style = @@default_style)
# # # #     p style
# # # #   end
# # # #   def self.load_from_file(file)
# # # #     Node.new # TODO
# # # #   end
# # # # end
# # # # Node.new.render
# # # # Node.load_from_file('widget1.json').render

# # # # # Orc = Class.new do
# # # # #   def eat
# # # # #     @energy = 100
# # # # #   end
# # # # # end

# # # # # class Orc
# # # # #   def eat(energy = 1)
# # # # #     # the first time the method is called
# # # # #     @energy = @energy || Orc.default_energy
# # # # #     @energy += energy
# # # # #   end
# # # # #   def self.default_energy
# # # # #     100
# # # # #   end
# # # # # end
# # # # # fred = Orc.new
# # # # # fred.eat
# # # # # p fred.class # Orc
# # # # # p Orc.instance_methods(false) # [:eat]
# # # # # p Orc.class  # Class
# # # # # p Orc.methods.grep /^new/
# # # # # # p Orc.class.instance_methods(false) # [:allocate, :superclass, :new]
# # # # # # p fred.methods

# # # # # class F
# # # # #   def initialize(is_orange)
# # # # #     if is_orange
# # # # #       @orange = true
# # # # #     else
# # # # #       @apple = true
# # # # #     end
# # # # #   end
# # # # # end
# # # # # p F.new(false).instance_variables # => [:@apple]
# # # # # p F.new(true).instance_variables # => [:@orange]
# # # # # p F.new(true).class
# # # # # p F.class
# # # # # # p Class.methods

# # # # # def f(a, &block)
# # # # #   throw 'No block passed' unless block_given?
# # # # #   p a
# # # # #   block.call
# # # # # end

# # # # # f(1){print 'block'}

# # # # # class C
# # # # #   def C.m1
# # # # #   end
# # # # # end
# # # # # # p C.singleton_methods, C.methods, C.new.singleton_methods

# # # # # c = C.new
# # # # # class << c
# # # # #   def s1
# # # # #   end
# # # # # end
# # # # # # p c.singleton_methods

# # # # # # require 'pp'

# # # # # # pretty_inspect c
