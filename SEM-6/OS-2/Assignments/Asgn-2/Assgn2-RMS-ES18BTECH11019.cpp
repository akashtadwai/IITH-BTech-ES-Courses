#include <bits/stdc++.h>
using namespace std;
#define tuple array<int, 2>

typedef struct { // PCB block
  int pid, burst_time, period, next_deadline, k,
      k1; // k = no.of repetitions, k1 is used for calculating stats
  double waiting_time, start_time;
  bool flag = false; // To know if a process is preempted
  bool operator()(const tuple &a,
                  const tuple &b) { // High priority is given to process with
                                    // low period and if periods are same
    if (a[1] == b[1]) // The priority is given to process with lower pid
      return a[0] > b[0];
    return a[1] > b[1];
  }
} PCB;

void takeInput();
void printInfo(int pid);
int calcWaitingTime(int pid);
void finish(int pid);
void decidePreempt(int pid);
bool preemptCondition(int pid);

ifstream inp("inp-params.txt"); // streams for reading/writing
ofstream log_stream("RMS-Log.txt");
ofstream stats_stream("RMS-Stats.txt");

priority_queue<tuple, vector<tuple>, PCB> ready_q, next_processq; // ready_q is where processes are currently running
                   // next_processq contains when the processes arrives into
                   // ready queue.

vector<int> remaining_bt; // Array to store remaining burst times
vector<PCB> process;      // Array to store process info.
int n, misses = 0, pid, globalTimer = 0, total_processes = 0; // No of Misses,process id, globalTimer, total_processes

int main() {
  takeInput();

  while (!next_processq.empty() or !ready_q.empty()) { // Loop for every event

    if (!next_processq.empty() and globalTimer == next_processq.top()[1]) {
      pid = next_processq.top()[0];
      if (process[pid].k > 0) {
        if (remaining_bt[pid] != 0) {
          process[pid].waiting_time += process[pid].period; // when the process misses it's deadline
                                   // waiting_time=period
          process[pid].start_time = globalTimer;
          misses++;
          process[ready_q.top()[0]].next_deadline = INT_MAX;
          log_stream << "Process P" << pid << " missed deadline at time "
                     << globalTimer << "\n";
        } else {
          process[pid].start_time = globalTimer;
          ready_q.push({pid, process[pid].period});
        }
      }
      process[pid].k--;
      remaining_bt[pid] = process[pid].burst_time;
      process[pid].next_deadline = globalTimer + process[pid].period;
      next_processq.pop();
      if (process[pid].k > 0) {
        next_processq.push(
            {pid, process[pid]
                      .next_deadline}); // push other instances of the process.
      }
      continue;
    }
    if (ready_q.empty()) { // if ready_q is empty
      if (next_processq.empty())
        break;
      else { // if next_processq is empty then CPU is idle
        globalTimer = next_processq.top()[1];
        if (process[next_processq.top()[0]].k > 0)
          log_stream << "CPU is idle till time " << globalTimer << "\n";
        continue;
      }
    } else { // ready_q not empty
      pid = ready_q.top()[0];

      if (remaining_bt[pid] + globalTimer >
          process[pid].next_deadline) { // check if the process is schedulable.
        log_stream << "Even if Process P" << pid << " is scheduled now at "
                   << globalTimer << " it will certainly miss its deadline at "
                   << process[pid].next_deadline << "\n";
        remaining_bt[pid] = 0;
        misses++;
        process[pid].waiting_time += process[pid].period;
        process[ready_q.top()[0]].next_deadline =
            INT_MAX; // To not interfere with other processes
        ready_q.pop();
        continue;
      }
      printInfo(pid);
      if (next_processq.empty()) { // when next process queue is empty

        if (remaining_bt[pid] + globalTimer <=
            process[pid].next_deadline) { // Process completes its execution.
          process[pid].waiting_time += calcWaitingTime(pid);
          globalTimer += remaining_bt[pid];
          process[pid].next_deadline += process[pid].period;
          log_stream << "Process P" << pid << " finishes execution at time "
                     << globalTimer << "\n";
        } else { // Process misses its deadline
          misses++;
          process[pid].waiting_time += process[pid].period; // changed
          // globalTimer = process[pid].next_deadline; {changed}
          log_stream << "Process P" << pid << " missed deadline at time "
                     << process[pid].next_deadline << "\n";
        }
        remaining_bt[pid] = 0;
        ready_q.pop();
      }

      else { // 2 disjoint cases depending on top process of ready_q and
             // next_processsq
        if ((next_processq.top()[1] >= remaining_bt[pid] + globalTimer) and
            remaining_bt[pid] + globalTimer <=
                process[pid].next_deadline) { // process finishes execution
          finish(pid);
        }

        else if (next_processq.top()[1] <
                 process[pid].next_deadline) { // deciding for preemption
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

void takeInput() { // TakingInput
  inp >> n;
  remaining_bt.resize(n + 1);
  process.resize(n + 1);
  for (int i = 0; i < n; i++) {
    inp >> pid >> process[pid].burst_time >> process[pid].period >>
        process[pid].k;
    process[pid].k1 = process[pid].k;
    if (process[pid].k > 0) {
      next_processq.push({pid, 0}); // Next Priority_queue consists of
                                    // {pid,arrival_time in to ready_queue}
      log_stream << "Process P" << pid
                 << ": processing time=" << process[pid].burst_time
                 << "; deadline: " << process[pid].period
                 << "; period: " << process[pid].period
                 << "; joined the system at time " << globalTimer << "\n";
    }
    total_processes += process[pid].k;
    process[pid].next_deadline = process[pid].period;
  }
  inp.close();
}

void printInfo(int pid) { // Prints logs
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

int calcWaitingTime(int pid) { // waiting time definition
  return (globalTimer - process[pid].start_time - process[pid].burst_time +
          remaining_bt[pid]);
}

void finish(int pid) {
  process[pid].next_deadline += process[pid].period;
  process[pid].waiting_time += calcWaitingTime(pid);
  globalTimer += remaining_bt[pid]; // Process completely finishes
  log_stream << "Process P" << pid << " finishes execution at time "
             << globalTimer << "\n";
  remaining_bt[pid] = 0;
  ready_q.pop();
}

bool preemptCondition(int pid) { // preemption condition
  return (process[next_processq.top()[0]].k != 0) and
         ((process[next_processq.top()[0]].period < process[pid].period) or
          (process[next_processq.top()[0]].period == process[pid].period and
           next_processq.top()[0] < pid));
}

void decidePreempt(int pid) { // If condition for preemption is satisfied
                              // preempt else continue executing
  remaining_bt[pid] -= (next_processq.top()[1] - globalTimer);
  globalTimer = next_processq.top()[1];
  if (preemptCondition(pid)) {
    process[pid].flag = true;
    log_stream << "Process P" << pid << " is preempted by P"
               << next_processq.top()[0] << " at time " << globalTimer;
    log_stream << " Remaining processsing time: " << remaining_bt[pid] << "\n";
  }
}
