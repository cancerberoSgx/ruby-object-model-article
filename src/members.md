

## More on class members and messages

### Method visibility and private

Ruby language supports declaring methods as `public`, `protected` or `private`. In general they have the same purpose as in other languages such as Java or C# but in Ruby, `private` in particular has a peculiar semantics that can be summarized with a single simple rule: **private methods cannot be called with an explicit receiver**. Go back to section [Self: the default object](self-the-default-object) where we described messages with explicit receiver like `foo.bar()` versus messages with implicit `self` receiver like `bar()`. Then every time you call a private method, it must be on the implicit receiver: `self`. If an expression with an explicit receiver is used then it throws an error. 

The following is a controversial example which shows that a private method cannot be called, even from its own class if the message receiver is given explicitly:

```rb
class Foo
  def public_method
    self.private_method
  end
private
  def private_method; end
end
Foo.new.public_method
```

Running the snippet will throw `NoMethodError: private method 'private_method' called [...]`. To solve the problem we just need to replace `self.private_method` with `private_method` - in other words, call the private method with the implicit `self` receiver. 


<i id="accessor-methods"></i>

### Accessor methods 

Ruby supports method definition to handle attribute getter and assignation. 

```rb
class Bar
  def foo=(value)
    @foo = value
  end
  def foo
    @foo
  end
end
bar = Bar.new
bar.foo = 2
p bar.foo
```


<i id="accessors"></i>

### Accessors

Imagine we are writing a class `MyClass` with variables `foo` and `bar` and we want them to be available so users of our class can access or assign them like this:

```rb
class MyClass
  def initialize
    @foo = 1
    @bar = 2
  end
end
obj = MyClass.new
p obj.foo      # throws
obj.bar = 1    # throws
```

Instead of manually write accessor methods `foo`, `foo=`, `bar` and `bar=` as we shown in the [previous section](#accessor-methods), we could instruct Ruby to auto generate them automatically by using `Module#attr_*` methods. `Module#attr_reader` generates the readers, this is, `foo` and `bar`. `Module#attr_writer` generates the writers, this is, `foo=` and `bar=`. Finally `Module#attr_accessor` generate both: 

```rb
class MyClass
  attr_accessor :foo, :bar
  def initialize
    @foo = 1
    @bar = 2
  end
end
obj = MyClass.new
p obj.foo      # works
obj.bar = 1    # works
```



<i id="class-macros"></i>

### Class macros

The ability to run any code inside a class definition, plus its friendly syntax allow Ruby programmers to conceptualize what we call **class macros**. Formally, they are statements inside the class scope calling class methods to perform operations on the class itself, often using Ruby's meta programming API to modify the class behavior. 

When we described [accessors](#accessors), we where actually talking about `Module`'s class methods that are called in statements inside the class definition. The expression `attr_accessor :foo` for example is actually calling `Module#attr_accessor` method. 

For Ruby newcomers, expressions like `attr_accessor :foo` in the middle of class definitions could look like a syntax thing, but actually there's no special syntax at all, we are just calling a class method that will modify the class to support `attr_accessor` semantics.

Let's write our own class macro `second`, that, given a method named `name` it will create a second method named `"#{name}2"` that calls the original method and log the call:

```rb
class Base
  def self.second(*methods)
    methods.each{|method|
    define_method("#{method}2") do |*args, &block| 
      print "'#{method}' called"
      send method, *args, &block
    end
  }
  end
end
class Elf < Base
  second :foo
  def foo; end
end
elf = Elf.new
elf.foo
elf.foo2 # => 'method' called
```

<!-- Ruby's `Module` class, for example, comes with a variety of class-level utilities to control how user access object's attributes as described . The expression `attr :foo` for example -->


<i id="operator-overloading"></i>

### Operator overloading

Ruby permits operator overloading, allowing one to define how an operator shall be used in a particular program. For example a `+` operator can be define in such a way to perform subtraction instead addition and vice versa. The operators that can be overloaded are `+`, `-`, `/`, `*`, `**`, `%`, etc and some operators that can not be overloaded are `&`, `&&`, `|`, `||`, `()`, `{}`, `~`, etc.

Operator functions are same as normal functions. The only differences are, name of an operator function is always symbol of operator followed operator object. Operator functions are called when the corresponding operator is used. Operator overloading is not commutative that means that `3 + a` is not same as `a + 3`.

In the following example we write the backbones of a class for complex numbers and implement the `+` operator.

```rb
class ComplexNumber
  attr_reader :real, :imaginary
  def initialize(real = 0, imaginary = 0)
    @real = real
    @imaginary = imaginary
  end
  def +(other)
    ComplexNumber.new @real + other.real, @imaginary + other.imaginary
  end
  def to_s
    "ComplexNumber(#{@real}, #{@imaginary})"
  end
end
a = ComplexNumber.new(1, 1)
b = ComplexNumber.new(2, 2)
print a + b # => ComplexNumber(3, 3)
```



<div class="page-break"></div>


