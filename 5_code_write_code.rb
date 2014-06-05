module CheckedAttributes
	def self.included(klass)
		klass.extend(ClassMethods)

		# Another solution to use class_eval
		# klass.class_eval do 
		# 	def self.attr_checked(sym)
		# 		...
		# 	end
		# end
	end

	module ClassMethods
		def attr_checked(sym)
			# Getter
			define_method "#{sym}" do
				self.instance_variable_get("@#{sym}")
			end

			# Setter
			define_method "#{sym}=" do |val|
				valid = yield(val)

				if valid
					self.instance_variable_set("@#{sym}", val)
				else
					raise "Invalid Assignment"
				end
			end
		end
	end

end

####################################

class Person
	include CheckedAttributes
	attr_checked :age do |v|
		v >= 18
	end
end

me = Person.new
me.age = 39
# me.age = 12 => will throw exception
puts me.age