#include <iomanip>
#include <iostream>
#include <time.h>
using namespace std;
void measure() {
  for (int i = 0; i < 100; i++) {
  }
}
int main() {
  clock_t st, end;
  st = clock();  // starting the clock
  measure();     // measuring time
  end = clock(); // end time
  double time_taken = double(end - st) / double(CLOCKS_PER_SEC);
  cout << fixed << setprecision(10);
  cout << "Time taken by program is : " << time_taken << " sec "
       << "\n";
}