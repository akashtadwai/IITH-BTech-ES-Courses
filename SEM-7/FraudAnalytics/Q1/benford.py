"""
To run: python3 benford.py
"""


import math
import pandas as pd
from scipy.stats import chisquare as chi2


__AUTHORS__ = [
    ("Vinta Reethu", "ES18BTECH11028"),
    ("Akash Tadwai", "ES18BTECH11019"),
    ("Chaitanya Janakie", "CS18BTECH11036"),
]


class BenfordsLaw:
    def __init__(self, numDigits: int):
        # 10^(numDigits-1) to (10^numDigits)
        self.leftRange = pow(10, numDigits - 1)
        self.rightRange = pow(10, numDigits)

        self.benford = [
            math.log((x + 1) / x, 10) for x in range(self.leftRange, self.rightRange)
        ]

    def digit_counts(self, numbers: list) -> list:
        data = list(numbers[numbers > 1])

        for i in range(len(data)):
            while data[i] > self.rightRange:
                data[i] = data[i] / 10

        first_digits = [int(x) for x in data]
        freqArr = [0] * (self.rightRange - self.leftRange)
        for x in first_digits:
            freqArr[x - self.leftRange] += 1
        total_count = len(data)
        digit_probs = [(i / total_count) for i in freqArr]

        return digit_probs

    def chi_square(self, digits_count, expected_count) -> None:
        chi_2, pvalue = chi2(digits_count, f_exp=expected_count)
        print(f"Chi-square test statistic: {chi_2}")
        print(f"Chi-square p-value: {pvalue}")

    def mad_value(self, digits_count, expected_count) -> None:
        mad_value = 0

        for current, expected in zip(digits_count, expected_count):
            mad_value += abs(current - expected)

        mad_value /= min(len(digits_count), len(expected_count))

        print(f"MAD Value = {mad_value}")


if __name__ == "__main__":

    dataset = pd.read_csv("benford.csv", encoding="latin-1")
    datasetLen = len(dataset)
    for numDigs in [1, 2]:
        benfordsLaw = BenfordsLaw(numDigs)
        digits_probs = benfordsLaw.digit_counts(dataset.Population)
        if numDigs == 1:
            print("First ", end="")
        else:
            print("Second ", end="")
        print("Digit Probabilities:")
        for i in range(1, benfordsLaw.rightRange - benfordsLaw.leftRange + 1):
            if numDigs == 1:
                print(
                    f"Digit: {i}  Observed: {digits_probs[i-1]:.6f}  Expected: {benfordsLaw.benford[i-1]:.6f}"
                )
            else:
                print(
                    f"Digit: {i+9}  Observed: {digits_probs[i-1]:.6f}  Expected: {benfordsLaw.benford[i-1]:.6f}"
                )

        benfordsLaw.chi_square(
            [ele * datasetLen for ele in digits_probs],
            [ele * datasetLen for ele in benfordsLaw.benford],
        )
        benfordsLaw.mad_value(digits_probs, benfordsLaw.benford)
        print("\n\n")
