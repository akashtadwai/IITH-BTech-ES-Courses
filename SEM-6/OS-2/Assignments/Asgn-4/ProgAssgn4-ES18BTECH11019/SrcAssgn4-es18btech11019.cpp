#include <chrono>
#include <fstream>
#include <iostream>
#include <map>
#include <random>
#include <semaphore.h>
#include <sys/time.h>
#include <thread>
#include <time.h>
#include <unistd.h>
#include <vector>
using namespace std;

int n, x;
double lamda, r, _gamma;

sem_t eat_lock, block_lock;
int eating = 0, waiting = 0;
bool must_wait = false;

default_random_engine generator(time(NULL));
time_t t;
multimap<string, string> info; // A map to store thread info sorted by arrival time

chrono::duration<double,std::micro> waiting_time(0), temp(0);

string getSysTime() { // getSystem Time in  HH:MM:SS:millisec:musec format
  char buf[26];
  time(&t);
  struct tm *time_info;
  struct timeval tv;
  gettimeofday(&tv, NULL);
  time_info = localtime(&t);
  int ms = tv.tv_usec / 1000, musec = tv.tv_usec % 1000;
  sprintf(buf, "%.2d:%.2d:%.2d:%.3d:%.3d", time_info->tm_hour,
          time_info->tm_min, time_info->tm_sec, ms,
          musec); // writing time to buffer
  string sysTime(buf);
  return sysTime;
}

void Dining(int tid) {
  exponential_distribution<double> delay(_gamma);
  chrono::time_point<chrono::system_clock> start_time, end_time;

  start_time = chrono::system_clock::now();
  string cur_time = getSysTime();
  string request =
      to_string(tid + 1) + " th Customer access request at " + cur_time;

  // EATING
  sem_wait(&eat_lock);
  info.insert({cur_time, request}); // inserting thread info atomically
  if (must_wait == true and eating + 1 > x) {
    waiting++;
    must_wait = true;
    sem_post(&eat_lock);
    sem_wait(&block_lock);
    cur_time = getSysTime();
    request = to_string(tid + 1) + " th Customer given access at " + cur_time;
  } else {
    eating++;
    end_time = chrono::system_clock::now();
    temp = (end_time - start_time);
    waiting_time += temp;
    cur_time = getSysTime();
    request = to_string(tid + 1) + " th Customer given access at " + cur_time;
    must_wait = (waiting > 0 && eating == x);
    sem_post(&eat_lock);
  }
  usleep(delay(generator) * 1e3); // eating for sometime

  // EXITING

  sem_wait(&eat_lock);
  info.insert({cur_time, request}); // insert atomically so threads won't
                                    // override each other's locations
  --eating;
  cur_time = getSysTime();
  request = to_string(tid + 1) + " th Customer Exits at " + cur_time;
  info.insert({cur_time, request});
  if (eating == 0) {
    int k = min(x, waiting);
    waiting -= k;
    eating += k;
    must_wait = (waiting > 0 && eating == x);
    for (int i = 0; i < k; i++) {
      sem_post(&block_lock);
    }
  }
  sem_post(&eat_lock);
}

int main() {
  ifstream fin("input.txt");
  fin >> n >> x >> lamda >> r >> _gamma;
  fin.close();

  sem_init(&eat_lock, 0, 1);
  sem_init(&block_lock, 0, 0);

  vector<thread> t; // Array of n threads

  int up_bound = r * x;
  uniform_int_distribution<int> uniform(1, up_bound);
  exponential_distribution<double> exponential(lamda);
  int num_people = 0;
  while (num_people < n) {
    int people = uniform(generator);
    while (people > (n - num_people))
      people = uniform(generator);
    for (int i = num_people; i < num_people + people; i++)
      t.push_back(thread(Dining, i));
    usleep(exponential(generator) * 1e3);
    num_people += people;
  }

  for (int i = 0; i < n; i++)
    t[i].join();

  ofstream fout("Korean-Log.txt", std::ios::out | std::ofstream::app);
  char header[100];
  sprintf(header, "N = %d, X= %d, lambda = %lf, r= %lf, gamma = %lf \n\n", n, x,
          lamda, r, _gamma);
  fout << header;
  for (auto itr : info)
    fout << itr.second << endl;

  fout << "\n\n";
  fout.close();

  fout.open("Korean-Stats.txt", std::ios::out | std::ofstream::app);
  fout << (waiting_time.count() / n) << "\n";

  cout << "Average waiting time = " << (waiting_time.count() / n) 
       << " mu_sec\n";

  fout.close();

  return 0;
}
