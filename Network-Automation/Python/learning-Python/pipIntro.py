#Pip installation can be checked from python Scripts directory.
#Figure out where python is installed -
#       cmd
#       where python
#       exit
# To check pip installation - 
#       cd C:\Users\austi\AppData\Local\Programs\Python\Python39\Scripts
#       pip --version
# https://www.activestate.com/blog/top-10-must-have-python-packages/

#Impot currency converter for usage
from currency_converter import CurrencyConverter
c = CurrencyConverter()

#Ask user for data
data = input("\nEnter how many USD you would like to convert to EUR \n")
#Convert entered data to integer
inputNumber = int(data)

#take entered data and convert to EUR
EUR = c.convert(inputNumber, 'USD') 

print(EUR)