#include <atomic>
#include <chrono>
#include <fstream>
#include <iostream>
#include <random>
#include <sys/time.h>
#include <thread>
#include <time.h>
#include <unistd.h>

#include <vector>
using namespace std;

atomic_flag lock = ATOMIC_FLAG_INIT; // Atomic bool variable flag set to false
int n, k; // No. of threads and no of times each thread will enter the CS
double lambda_1, lambda_2; // λ1, λ2
time_t t;
chrono::duration<double> waiting_time(0), max_waiting_time(-1), temp(0);

FILE *fout = fopen("TAS-Log.txt", "a+");

string getSysTime() { // getSystem Time in HH:MM:SS:millisec:musec format
  char buf[26];
  time(&t);
  struct tm *time_info;
  struct timeval tv;
  gettimeofday(&tv, NULL);

  int ms = tv.tv_usec / 1000, musec = tv.tv_usec % 1000;
  time_info = localtime(&t);
  sprintf(buf, "%.2d:%.2d:%.2d:%.3d:%.3d", time_info->tm_hour,
          time_info->tm_min, time_info->tm_sec, ms, musec);
  string sysTime(buf);
  return sysTime;
}

void testCS(int tid) {

  default_random_engine generator(time(NULL));
  exponential_distribution<double> d1(lambda_1); // critical section time
  exponential_distribution<double> d2(lambda_2); // remainder section time
  chrono::time_point<chrono::system_clock> start_time, end_time;

  for (int i = 0; i < k; i++) {
    // entry section
    fprintf(fout, "%d th CS Requested at %s by thread %d\n", i + 1,
            getSysTime().c_str(), tid + 1);

    start_time = chrono::system_clock::now();
    while (lock.test_and_set())
      ; // Test and Set implementation
    end_time = chrono::system_clock::now();

    // Critical Section Starts

    temp = (end_time - start_time);
    waiting_time += temp;                           // Calculating waiting time
    max_waiting_time = max(max_waiting_time, temp); // Updating max time taken

    fprintf(fout, "%d th CS Entered at %s by thread %d\n", i + 1,
            getSysTime().c_str(), tid + 1);
    usleep(d1(generator) * 1e3);
    fprintf(fout, "%d th CS Exited at %s by thread %d\n", i + 1,
            getSysTime().c_str(), tid + 1);

    lock.clear();

    // Critical Section Ends

    usleep(d2(generator) * 1e3);
  }
}

int main() {
  ifstream fin("inp-params.txt");
  fin >> n >> k >> lambda_1 >> lambda_2;
  fin.close();
  vector<thread> t; // Array of n threads
  fprintf(fout, "Running for n=%d, k=%d, lamda1=%lf, lamda2=%lf \n\n", n, k,
          lambda_1, lambda_2);
  for (int i = 0; i < n; i++)
    t.push_back(thread(testCS, i));
  for (int i = 0; i < n; i++)
    t[i].join();
  fprintf(fout, "\n\n");
  fclose(fout);

  ofstream fout("TAS-Stats.txt", std::ios::out | std::ofstream::app);
  fout << "Average time = " << waiting_time.count() / (n * k) << "s\n";
  fout << "Max waiting time = " << max_waiting_time.count() << "s\n\n";
  fout.close();
  return 0;
}
