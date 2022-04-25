#Write function to return largest gap between elements in a list after its been sorted

largest_gap = [9,4,26,26,0,0,5,20,6,25,5]

def findLargestGap(list):
    largestGap = []
    sortList = sorted(list)
    for i in range(len(sortList)- 1):
        largestGap.append(sortList[i+1]-sortList[i])
    print("The largest element gap in the list is :" + str(max(largestGap)))
    print(sortList)

findLargestGap(largest_gap)