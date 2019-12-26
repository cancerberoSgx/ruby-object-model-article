# frozen_string_literal: true
require_relative('test_util')

assert_equal self.class, Object
# p self.methods.sort
assert_equal self.class.ancestors, [Object, Kernel, BasicObject]
assert_equal nil, (self.methods.find { |method| method == :method1 })
self.class.class_eval do
    def method1
      'method1'
    end
end
assert_equal nil, (self.methods.find { |method| method == :method1 })

self = 1
assert_equal self.class, Number
# p [1,2,3]==[1,2]

# require 'test/unit'

# GLOBAL_SCOPE = self

# class SelfScopeTest < Test::Unit::TestCase
#   def test_scope_self_simple
#     assert_equal GLOBAL_SCOPE.class.ancestors, [Object, Kernel, BasicObject]
#     assert_equal nil, (GLOBAL_SCOPE.methods.find { |method| method == 'method1' })
#     GlobalScopeClass = GLOBAL_SCOPE.class
#     class GlobalScopeClass
#       def method1
#         'method1'
#       end
#     end
#     assert_equal nil, (GLOBAL_SCOPE.methods.find { |method| method == 'method1' })

#   end
# end
