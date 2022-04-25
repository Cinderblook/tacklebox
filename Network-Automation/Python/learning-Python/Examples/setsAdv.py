#Create a new set from two sets
w_c = {"white","blue"}
f_c = {"orange","brown","blue"}

a_c = w_c.union(f_c)
print(a_c)

#intersection(keeps values that exist in both)
s_c = w_c.intersection(f_c)
print(s_c)

#symmetric diff (keeps only unique colors or items)
u_c = w_c.symmetric_difference(f_c)
print(u_c)

#Is disjoint - determines if intersections exist
print(w_c.isdisjoint(f_c))