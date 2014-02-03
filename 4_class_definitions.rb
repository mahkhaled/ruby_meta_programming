result = class MyClass
  puts self.inspect # => MyClass
  self
end

result # => MyClass

def add_method_to(a_class)
  # No scope gates here also using class_eval
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
  def attr_accessor_methods(att)
    define_method("get_#{att}") do
      instance_variable_get("@#{att}".to_sym)
    end
  end
end

class MyClass
  # attr_accessor_methods is a method called over receiver self (MyClass)
  attr_accessor_methods :price
end

x = MyClass.new
x.instance_variable_set(:@price, 10)
x.get_price # => 10