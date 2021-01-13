#include <bits/stdc++.h>
using namespace std;

int main() {
  int var = -10;
  // Handling errors in C++
  cout << "Before try \n";
  try {
    cout << "Inside try \n";
    if (var < 0) {
      throw var;
      cout << "After throw (Never executed) \n";
    }
  } catch (int var) {
    cout << "Exception Caught \n";
  }
  cout << "After catch (Will be executed) \n";
  return 0;
}
