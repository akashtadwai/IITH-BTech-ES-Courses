# Find minimum integer coefficients for a chemical reaction like
#   a C6H12O6+ b  O2 -> c CO2 + d H20
import os 
import sympy
import re as regex
import os
import sys 

# matching a single element and optional count, like C6
element = regex.compile("([A-Z][a-z]?)([0-9]*)")

class BalanceEquation():

    def parse_compound(self,compound):
        """
        Given a chemical compound like C6H12O6,
        return a dictionary of element counts like {"C":6, "H":12, "O":6}
        """
        assert "(" not in compound, "This parser doesn't work with subclauses such as (OH)2"
        return {el: (int(num) if num else 1) for el, num in element.findall(compound)}

    def balance(self):
        """
        Taking arguments from java file and separting LHS and RHS
        """
        lst = [' {0} '.format(elem) for elem in sys.argv[1:]]
        eqn = ''.join(str(e) for e in lst)
        eqn_final = eqn.split('==')
        lhs_strings = eqn_final[0].split()
        lhs_strings.reverse()
        lhs_compounds = [self.parse_compound(compound) for compound in lhs_strings]
        rhs_strings = eqn_final[1].split()
        rhs_strings.reverse()
        rhs_compounds = [self.parse_compound(compound) for compound in rhs_strings]
        # Get list of elements
        els = sorted(set().union(*lhs_compounds, *rhs_compounds))
        els_index = dict(zip(els, range(len(els))))

        # Building matrix to solve
        w = len(lhs_compounds) + len(rhs_compounds)
        h = len(els)
        A = [[0] * w for _ in range(h)]
        # load with element coefficients
        for col, compound in enumerate(lhs_compounds):
            for el, num in compound.items():
                row = els_index[el]
                A[row][col] = num
        for col, compound in enumerate(rhs_compounds, len(lhs_compounds)):
            for el, num in compound.items():
                row = els_index[el]
                A[row][col] = -num   # invert coefficients for RHS

        # Solve using Sympy for absolute-precision math
        A = sympy.Matrix(A)  
        if not A.nullspace():
            print("Invalid Equation!!!")
            return   
        # finding first basis vector == primary solution
        coeffs = A.nullspace()[0]
        # finding least common denominator, multiply through to convert to integer solution
        coeffs *= sympy.lcm([term.q for term in coeffs])

        # Displaying result
        lhs = " + ".join(["{} {}".format(coeffs[i], s) for i, s in enumerate(lhs_strings)])
        rhs = " + ".join(["{} {}".format(coeffs[i], s) for i, s in enumerate(rhs_strings, len(lhs_strings))])
        print("{} --> {}".format(lhs, rhs))

if __name__ == "__main__":
    Equation=BalanceEquation()
    Equation.balance()