#This will try to illustrate the init function
#Class defined
class Car:
    #Intialize function
    def __init__(self,color,hp):
        #Set instance values of object to argument passed
        self.color = color
        self.hp = hp
    def car_description(self):
        print("The car is " + self.color + " with " + self.hp)
#Create Objects
acura = Car("White","150")
corvette = Car("Red","400")

corvette.car_description()
acura.car_description()

#call function, change property
acura.car_description()
acura.color="Black"

#inheret from car
class CarVin(Car):
    def __init__(self, color, hp, vin):
        super().__init__(color, hp)
        self.vin = vin

vw=CarVin("Blue", "90", "WVW")
vw.car_description()

print(vw.vin)