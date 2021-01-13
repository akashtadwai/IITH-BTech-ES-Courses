import sys


def this_fails():
    x = 10/0


try:
    this_fails()
except ZeroDivisionError as err:
    print('Handling run-time error:', err)
finally:
    print("Error is handled succesfully!")
# We can handle type errors and all type of errors using try, except and finally
# in python
