# Open class
class Numeric
  def to_money
    Money.new(self * 100)
  end
end

# Problems of open class (Monkey patch) is OVERWRITE existing method with the same name

# Unlike in Java, no connection between class and instance variables. 
# Instance variables just exists when you assign them a value
# two objects of the same class with two different instance variables
obj.instance_variables


obj.methods.grep(/my/) # => [:my_method]

# Class.instance methods vs object.methods (same)
String.instance_methods == "abc".methods # => true


# Any reference that begins with an uppercase letter, including the names
# of classes and modules, is a CONSTANT


# Method lookup (right, up) (image here)
MySubclass.ancestors # => [MySubclass, MyClass, Object, Kernel, BasicObject]


# you can NOT call a private method with an explicit receiver.

# module method lookup
class Book
  include Printable
  include Document

  # special case: in a class or module definition, the role of self is taken by the class or module
  self.ancestors # => [Book, Document, Printable, Object, Kernel, BasicObject]
end
