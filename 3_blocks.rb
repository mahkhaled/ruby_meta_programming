# Callable objects (blocks, lambda, procs)

def a_method
  return yield(2) if block_given?
  'no block'
end
a_method { |x| "here's a block!" * x } # => "here's a block!here's a block!"

# When you define the block, it simply grabs the BINDINGS that are there at that
# moment, and then it carries those BINDINGS along when you pass the block into a method
def my_method
  x = "Goodbye"
  yield("cruel" )
end

x = "Hello"
my_method do |y| 
  "#{x}, #{y} world"
  scoped_var = 1
end # => "Hello, cruel world"    END OF "Scope" not "Scope Gate" (will be explained soon)

# scoped_var # => Error!

##################################
# Scope Gates (class, module, def)
##################################
v1 = 1

class MyClass # SCOPE GATE: entering class
  v2 = 2
  local_variables # => ["v2"]
  
  def my_method # SCOPE GATE: entering def
    v3 = 3
    local_variables
  end # SCOPE GATE: leaving def
    
  local_variables # => ["v2"]
end # SCOPE GATE: leaving class

# No Gates
my_var = "Success"
MyClass = Class.new do
  puts "#{my_var} in the class definition!"
  
  define_method :my_method do
    puts "#{my_var} in the method!"
  end
end
MyClass.new.my_method

# instance_eval mix code and bindings
class MyClass
  def initialize
    @v = 1
  end
end
obj = MyClass.new
obj.instance_eval do
  self # => #<MyClass:0x3340dc @v=1>
  @v   # => 1
end

# Callable Objects (proc, lambda, method)
# block is not an object so that you can use proc to be an object
# Deferred Evaluation
dec = lambda {|x| x - 1 }
dec.class # => Proc
dec.call(2) # => 1


# & operator
def math(a, b)
  yield(a, b)
end
def teach_math(a, b, &operation)
  puts "Let's do the math:"
  puts math(a, b, &operation)
end
teach_math(2, 3) {|x, y| x * y}

# Procs VS. Lambdas (return, arity)
def double(callable_object)
  callable_object.call * 2
end
l = lambda { return 10 }
double(l) # => 20

p = Proc.new { return 10 } # => 10
# The following fails with a LocalJumpError
# double(p)


# Arity
p = Proc.new {|a, b| [a, b]}
p.call(1, 2, 3) # => [1, 2]
p.call(1) # => [1, nil]


