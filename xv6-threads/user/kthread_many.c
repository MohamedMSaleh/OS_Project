// Test: create and join multiple threads
#include "user/user.h"
#include "kernel/types.h"
#define NTHREADS 4
#define STACK_SIZE 4096

int shared = 0;
void thread_func() {
  printf("[thread_func] Thread running!\n");
  for (int i = 0; i < 1000; i++) shared++;
  kthread_exit(0);
}

int main() {
  int tids[NTHREADS];
  void *stacks[NTHREADS];
  for (int i = 0; i < NTHREADS; i++) {
    stacks[i] = malloc(STACK_SIZE);
    tids[i] = kthread_create(thread_func, stacks[i], STACK_SIZE);
    if (tids[i] < 0) printf("Failed to create thread %d\n", i);
  }
  for (int i = 0; i < NTHREADS; i++) {
    int status = 0;
    kthread_join(tids[i], &status);
    free(stacks[i]);
  }
  printf("[main] All threads joined. shared=%d (should be %d)\n", shared, NTHREADS*1000);
  exit(0);
}
