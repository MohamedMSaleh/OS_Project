// Test: create and join multiple threads
#include "user/user.h"
#include "kernel/types.h"
#define NTHREADS 4
#define STACK_SIZE 4096
#define TIMEOUT_TICKS 10000000

volatile int shared = 0;
void thread_func(void) {
  for (int i = 0; i < 1000; i++) {
    __sync_fetch_and_add(&shared, 1);
  }
  kthread_exit(0);
}

int main() {
  printf("[main] Starting kthread_many\n");
  int tids[NTHREADS];
  void *stacks[NTHREADS];
  for (int i = 0; i < NTHREADS; i++) {
    void *stack = malloc(STACK_SIZE);
    stacks[i] = stack;
    tids[i] = kthread_create(thread_func, stack, STACK_SIZE);
    printf("[main] kthread_create returned tid=%d for i=%d\n", tids[i], i);
    if (tids[i] < 0) printf("Failed to create thread %d\n", i);
  }
  for (int i = 0; i < NTHREADS; i++) {
    int status = 0;
    int ret = -1;
    int ticks = 0;
    while (ticks < TIMEOUT_TICKS) {
      ret = kthread_join(tids[i], &status);
      if (ret == 0) break;
      ticks++;
      if (ticks % 1000000 == 0) printf("[main] Waiting for thread %d to join...\n", i);
    }
    if (ret != 0) printf("[main] kthread_join failed or timed out for thread %d\n", i);
    free(stacks[i]);
  }
  printf("[main] All threads joined. shared=%d (should be %d)\n", shared, NTHREADS*1000);
  printf("[main] Exiting kthread_many\n");
  exit(0);
}
