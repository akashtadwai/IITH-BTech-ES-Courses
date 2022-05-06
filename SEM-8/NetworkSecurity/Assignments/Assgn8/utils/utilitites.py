from collections import defaultdict


class Counter:
    """
    Counter class to keep track of the number of packets sent and blocked
    """

    def __init__(self) -> None:
        """
        Initialize the counter
        """
        self.cnt_sent = defaultdict(int)
        self.cnt_blocked = defaultdict(int)
        self.numPackets = 0
        self.timeTaken = 0

    def increment(self, isSent: bool, attr: str) -> None:
        """
        Increment the counter
        """
        if isSent:
            self.cnt_sent[attr] += 1
        else:
            self.cnt_blocked[attr] += 1

    def getCount(self, isSent: bool, attr: str) -> int:
        """
        Get the count of the attribute
        @param: isSent: bool: True if the packet was sent, False if blocked
        @param: attr: str: attribute to get the count of
        @return: int: count of requested attribute
        """
        return self.cnt_sent[attr] if isSent else self.cnt_blocked[attr]

    def resetCounter(self):
        """
        Reset the counter
        """
        self.cnt_sent = defaultdict(int)
        self.cnt_blocked = defaultdict(int)
        self.numPackets = 0
        self.timeTaken = 0

