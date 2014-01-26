# Dynamic dispatch using Object#send() 
obj.send(:my_method, 3)

# Dynamic  method using define_method
class MyClass
  define_method :my_method do |my_arg|
    my_arg * 3
  end
end

class Computer
  def self.define_component(name)
    define_method(name) {
      info = @data_source.send "get_#{name}_info" , @id
      price = @data_source.send "get_#{name}_price" , @id
      result = "#{name.to_s.capitalize}: #{info} ($#{price})"
    }
  end

  # self here refers to Computer
  define_component :mouse
  define_component :cpu
  define_component :keyboard
end

# Ghost method
class Table
  def method_missing(id,*args,&block)
    return as($1.to_sym,*args,&block) if id.to_s =~ /^to_(.*)/
    return rows_with($1.to_sym => args[0]) if id.to_s =~ /^rows_with_(.*)/

    # super to throw exception if method not found    
    super
  end
end

# Ghost method won't appear in respond_to?, then lets override it
class Computer
  def respond_to?(method)
    # super is useful here also :)
    @data_source.respond_to?("get_#{method}_info" ) || super
  end
end

# Module#undef_method() removes all methods, including the inherited ones.
# Module#remove_method() removes the method from the receiver, but leaves inherited methods.


# Ghost method is slow, but can be fast if it create dymanic method inside the ghost

# DelegateClass( ) is a Mimic Method (241) that creates and returns a new Class. 
# This class defines a method_missing( ) that forwards calls to a wrapped object
class Manager < DelegateClass(Assistant)
  def initialize(assistant)
    super(assistant)
  end
end