import time


def measure():
    for i in range(100):
        pass


if __name__ == "__main__":
    start_time = time.time()  # starting time
    measure()  # measuring the time required using time module
print("%s seconds" % (time.time() - start_time))  # ending time
