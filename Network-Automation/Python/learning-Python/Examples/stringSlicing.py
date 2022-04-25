#This progrma will illustrate how string slicing is done

sample_string = "Test String"
#positive slicing
#print an index
print(sample_string[0])
#print from 0-3 but not including 3
print(sample_string[0:3])
#print from a position [3] to the end
print(sample_string[3:])
#print from start to a specified position [3]
print(sample_string[:3])

#negative slicing
print(sample_string[-1])
#print from a negative index to another negative index (Not including -2)
print(sample_string[-4:-2])