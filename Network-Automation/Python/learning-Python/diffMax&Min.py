#Given a number return difference between max and min numbers that can be formed when digits are rearranged

number = "972882"

def rearranged_difference(number):
    elementList = [int(x) for x in str(number)]
    elementListLarg = [""]
    elementListSmall = [""]
    elementListLarg = elementList.sort(reverse = True)
    elementListSmall = elementList.sort()
    print(str(elementListLarg) + str(elementListSmall))
   
    maximum = [str(x) for x in elementListLarg]
    minimum = [str(x) for x in elementListSmall]

    maxNum = int("".join(maximum))
    minNum = int("".join(minimum))

        


print("The difference between max and minimum of " + number + " would be: " + str(rearranged_difference(number)))