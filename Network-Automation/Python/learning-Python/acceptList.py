def uniqueNumbers (inputList):
    
   #Create null list for data
    dataListUnique = []
    for data in inputList:
        if data not in dataListUnique:
            dataListUnique.append(data)
    for data in dataListUnique:
        print (data),
    
dataList = [2, 4, 5, 6, 5, 4, 2, 7, 8, 4, 10]
print("These are the unique values in the list: ")
uniqueNumbers(dataList)