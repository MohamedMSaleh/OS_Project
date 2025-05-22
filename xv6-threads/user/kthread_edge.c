// Test: join on non-existent TID and double join
#include "user/user.h"
#include "kernel/types.h"
#define STACK_SIZE 4096

void thread_func() { kthread_exit(123); }

int main() {
  void *stack = malloc(STACK_SIZE);
  int tid = kthread_create(thread_func, stack, STACK_SIZE);
  int status = 0;
  int ret1 = kthread_join(tid, &status);
  int ret2 = kthread_join(tid, &status); // should fail
  int ret3 = kthread_join(99999, &status); // should fail
  printf("join1=%d join2=%d join3=%d status=%d\n", ret1, ret2, ret3, status);
  free(stack);
  exit(0);
}
