# frozen_string_literal: true

def assert_equal(expected, actual, msg = "Expected #{expected} to equal #{actual}")
  throw msg unless expected == actual
end

def assert(actual, msg = "Expected #{actual} to be truthy")
  throw msg unless actual
end
