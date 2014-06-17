result = class MyClass
  puts self.inspect # => MyClass
  self
end

result # => MyClass

def add_method_to(a_class)
  # No scope gates here also using class_eval
  # can't use define_method because define_method is a private method
  a_class.class_eval do
    def m; 'Hello!' ; end
  end
end
add_method_to String
"abc".m # => "Hello!"


class MyClass
  # defined methods with def become instance methods of the "current class"
  def method_one
    # self is the object. However, current class is MyClass
    def method_two; 'Hello!' ; end
  end
end
obj = MyClass.new
obj.method_one
obj.method_two # => "Hello!"

# instance_eval only changes self, while class_eval changes both "self" and the "current class"


# Class instance variables
class MyClass
  @my_var = 1

  def self.read; @my_var; end
  def write; @my_var = 2; end
  def read; @my_var; end
end
obj = MyClass.new
obj.write
obj.read # => 2
MyClass.read # => 1

# class variables
class MyClass
  @@my_class_var = 10
  def m; @@my_class_var; end
  def self.m; @@my_class_var; end
end
MyClass.new.m # => 10
MyClass.m # => 10

# Class variables are different from Class Instance Variables,
# because they can be accessed by subclasses and by regu-lar instance methods. 

# Singleton Method add method ONLY to a certain object not all class objects
str = "just a regular string"
def str.title?
  self.upcase == self
end
str.title? # => false
str.methods.grep(/title?/) # => ["title?"]
str.singleton_methods # => ["title?"]


class MyClass
  puts self # => MyClass
  # self.my_class_method is the same like singleton_method concept
  # class method is a special kind for singleton method
  def self.my_class_method
    "class method"
  end
end

# class macros
class Class
  def attr_reader_methods(att)
    define_method("get_#{att}") do
      instance_variable_get("@#{att}".to_sym)
    end
  end
end

class MyClass
  # attr_accessor_methods is a method called over receiver self (MyClass)
  attr_reader_methods :price
end

x = MyClass.new
x.instance_variable_set(:@price, 10)
x.get_price # => 10


################################
# Eigenclasses and method lookup
################################
# how singleton method works with method lookup?
# Figuer 4.5, 4.6


# when a class includes a module, it gets the module's instance methods NOT the class methods
module MyModule
  def self.my_method; 'hello' ; end
end

class MyClass
  include MyModule
end
# MyClass.my_method # NoMethodError!

# Solution (class extension)
module MyModule
  def my_method; 'hello' ; end
end

class MyClass
  class << self
    include MyModule
  end
end
MyClass.my_method # => "hello"

# the same can be written by extend shortcut
MyClass.extend MyModule

#################
# alias (new old)
#################
class MyClass
  def my_method; 'my_method()' ; end
  alias :m :my_method # without comma :|
end
obj = MyClass.new
obj.my_method # => "my_method()"
obj.m # => "my_method()"


# What happens if you alias a method and then redefine it? (See the old one)
class String
  alias :real_length :length
  
  
  def length
    real_length > 5 ? 'long' : 'short'
  end
end
"War and Peace".length # => "long"
"War and Peace".real_length # => 13
