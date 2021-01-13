def fun():
    for i in rang(100):
        pass


if __name__ == "__main__":
    a = "This is an error message"
    print(a)
    if a:
    a += '5'
# This shows only an error at line 8 as expected an indented block
#  eventhough we wrote "range" spelling wrong
