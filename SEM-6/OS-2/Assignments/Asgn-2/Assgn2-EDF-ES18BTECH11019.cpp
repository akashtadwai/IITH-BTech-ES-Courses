#include <bits/stdc++.h>
using namespace std;
#define tuple array<int, 2>

typedef struct {
  int pid, burst_time, period, next_deadline, k,k1; // k = no.of repetitions, k1 is used for calculating stats
  double waiting_time, start_time;
  bool flag = false; // To know if a process is preempted
  bool operator()(const tuple &a, const tuple &b) { // Assigning priorities based on next_deadline
    if (a[1] == b[1])
      return a[0] > b[0];
    return a[1] > b[1];
  }
} PCB;

void takeInput();
void printInfo(int pid);
int calcWaitingTime(int pid);
void finish(int pid);
void decidePreempt(int pid);
bool preemptionCondition(int pid);

ifstream inp("inp-params.txt");
ofstream log_stream("EDF-Log.txt");
ofstream stats_stream("EDF-Stats.txt");

priority_queue<tuple, vector<tuple>, PCB> ready_q, next_processq;

vector<int> remaining_bt; // Array to store remaining burst times
vector<PCB> process;      // Array to store process info.
int n, misses = 0, pid, globalTimer = 0,total_processes = 0; // No of Misses,process id, globalTimer, total_processes



int main() {
  takeInput();

  while (!next_processq.empty() or !ready_q.empty()) { // Loop for every event

    if (!next_processq.empty() and globalTimer == next_processq.top()[1]) {
      pid = next_processq.top()[0];
      process[pid].next_deadline = globalTimer + process[pid].period;
      if (process[pid].k > 0) {
        if (remaining_bt[pid] != 0) {
          process[pid].waiting_time += process[pid].period; // when the process misses it's deadline waiting_time=period
          process[pid].start_time = globalTimer;
          misses++;
          ready_q.pop();
          ready_q.push({pid, process[pid].next_deadline});
          log_stream << "Process P" << pid << " missed deadline at time "
                     << globalTimer << "\n";
        } else {
          process[pid].start_time = globalTimer;
          ready_q.push({pid, process[pid].next_deadline});
        }
      }
      process[pid].k--;
      remaining_bt[pid] = process[pid].burst_time;
      process[pid].next_deadline = globalTimer + process[pid].period;
      next_processq.pop();
      if (process[pid].k > 0) {
        next_processq.push({pid, process[pid].next_deadline}); // pushing other instances of process
      }
      continue;
    }
    if (ready_q.empty()) {
      if (next_processq.empty())
        break;
      else {
        globalTimer = next_processq.top()[1];
        if (process[next_processq.top()[0]].k > 0)
          log_stream << "CPU is idle till time " << globalTimer << "\n";
        continue;
      }
    } else { // ready_q not empty
      pid = ready_q.top()[0];

      if (remaining_bt[pid] + globalTimer > process[pid].next_deadline) {
        log_stream
            << "Even if Process P" << pid
            << " is scheduled now at " << globalTimer<<" it will certainly miss its deadline at "
            << process[pid].next_deadline << "\n";
        remaining_bt[pid] = 0;
        misses++;
        process[pid].waiting_time += process[pid].period;
        process[ready_q.top()[0]].next_deadline=INT_MAX; // To not interfere with other processes
        ready_q.pop();
        continue;
      }
      printInfo(pid);
      if (next_processq.empty()) { // when next process queue is empty

        if (remaining_bt[pid] + globalTimer <=
            process[pid].next_deadline) { // Process completes execution
          process[pid].waiting_time += calcWaitingTime(pid);
          globalTimer += remaining_bt[pid];
          process[pid].next_deadline += process[pid].period;
          log_stream << "Process P" << pid << " finishes execution at time "
                     << globalTimer << "\n";
        } else { // Process misses its deadline
          misses++;
          process[pid].waiting_time += process[pid].period; // changed
          log_stream << "Process P" << pid << " missed deadline at time "
                     << process[pid].next_deadline << "\n";
          process[pid].next_deadline += process[pid].period;
        }
        remaining_bt[pid] = 0;
        ready_q.pop();
      }

      else { // 2 disjoint cases depending on top process of ready_q and
             // next_processsq
        if ((next_processq.top()[1] >= remaining_bt[pid] + globalTimer) and
            remaining_bt[pid] + globalTimer <= process[pid].next_deadline) {
          finish(pid);
        }

        else if (next_processq.top()[1] < process[pid].next_deadline) {
          decidePreempt(pid);
        }
      }
    }
  }

  log_stream.close();
  
  double AvgWaitingTime = 0;
  for (int pid = 1; pid <= n; pid++) {
    process[pid].waiting_time /= process[pid].k1;
    AvgWaitingTime += process[pid].waiting_time;
  }

  AvgWaitingTime /= n;
  stats_stream << "Number of processes that came into the system: "
               << total_processes << "\n";
  stats_stream << "Number of processes successfully completed: "
               << total_processes - misses << "\n";
  stats_stream << "Number of processes missed deadline:" << misses << "\n";
  stats_stream << "Average wait times for Processes:" << endl;
  for (int i = 1; i <= n; i++) {
    stats_stream << "P" << i << ": " << process[i].waiting_time << endl;
  }
  stats_stream << "Total Avg waiting time is: ";
  stats_stream << AvgWaitingTime << "\n";
  stats_stream.close();
  
  return 0;
}

void takeInput() {
  inp >> n;
  remaining_bt.resize(n + 1);
  process.resize(n + 1);
  for (int i = 0; i < n; i++) {
    inp >> pid >> process[pid].burst_time >> process[pid].period >>
        process[pid].k;
    process[pid].k1=process[pid].k; // Used for further calculations
    if (process[pid].k > 0) {
      next_processq.push({pid, 0});
      log_stream << "Process P" << pid
                 << ": processing time=" << process[pid].burst_time
                 << "; deadline: " << process[pid].period
                 << "; period: " << process[pid].period
                 << "; joined the system at time " << globalTimer << "\n";
    }
    total_processes += process[pid].k;
  }
  inp.close();
}

void printInfo(int pid) {
  if (process[pid].burst_time == remaining_bt[pid]) {
    process[pid].flag = false;
    log_stream << "Process P" << pid << " starts execution at time "
               << globalTimer << "\n";

  } else if (process[pid].flag) {
    // Execution resumes
    process[pid].flag = false;
    log_stream << "Process P" << pid << " resumes execution at time "
               << globalTimer << "\n";
  }
}

int calcWaitingTime(int pid) {
  return (globalTimer - process[pid].start_time - process[pid].burst_time +
          remaining_bt[pid]);
}

void finish(int pid) {
  process[pid].next_deadline += process[pid].period;
  process[pid].waiting_time += calcWaitingTime(pid);
  globalTimer += remaining_bt[pid]; // Process completely
  log_stream << "Process P" << pid << " finishes execution at time "
             << globalTimer << "\n";
  remaining_bt[pid] = 0;
  ready_q.pop();
}

bool preemptCondition(int pid){ // preemption condition
  return ( process[next_processq.top()[0]].k != 0) and
         ((process[next_processq.top()[0]].next_deadline <
           process[pid].next_deadline) or
          (process[next_processq.top()[0]].next_deadline ==
               process[pid].next_deadline and
           next_processq.top()[0] < pid));
}

void decidePreempt(int pid) {
  remaining_bt[pid] -= (next_processq.top()[1] - globalTimer);
  globalTimer = next_processq.top()[1];
  if (preemptCondition(pid)) {
    process[pid].flag = true;
    log_stream << "Process P" << pid << " is preempted by P"
               << next_processq.top()[0] << " at time " << globalTimer;
   
    log_stream << " Remaining processsing time: " << remaining_bt[pid] << "\n";
  }
}
