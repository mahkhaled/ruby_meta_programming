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
end # => "Hello, cruel world"

scoped_var # => Error!

