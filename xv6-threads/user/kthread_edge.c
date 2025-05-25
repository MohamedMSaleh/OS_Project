// Test: join on non-existent TID and double join
#include "user/user.h"
#include "kernel/types.h"
#define STACK_SIZE 4096
#define TIMEOUT_TICKS 10000000

void thread_func() { kthread_exit(123); }

int main() {
  printf("[main] Starting kthread_edge\n");
  void *stack = malloc(STACK_SIZE);
  int tid = kthread_create(thread_func, stack, STACK_SIZE);
  printf("[main] kthread_create returned tid=%d\n", tid);
  if (tid < 0) {
    printf("kthread_create failed\n");
    exit(1);
  }
  int status = 0;
  int ret = -1;
  int ticks = 0;
  while (ticks < TIMEOUT_TICKS) {
    ret = kthread_join(tid, &status);
    if (ret == 0) break;
    ticks++;
    if (ticks % 1000000 == 0) printf("[main] Waiting for thread to join...\n");
  }
  if (ret == 0) {
    printf("[main] Thread joined, exit status: %d\n", status);
  } else {
    printf("[main] kthread_join failed or timed out\n");
  }
  // Double join
  ret = kthread_join(tid, &status);
  printf("[main] Double join returned: %d (should fail)\n", ret);
  // Join on invalid TID
  ret = kthread_join(9999, &status);
  printf("[main] Join on invalid TID returned: %d (should fail)\n", ret);
  free(stack);
  printf("[main] Exiting kthread_edge\n");
  exit(0);
}
