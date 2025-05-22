// Simple test for kernel threads in XV6
#include "kernel/types.h"
#include "user/user.h"

#define STACK_SIZE 4096

void thread_func() {
  printf("Hello from thread! tid=%d\n", kthread_join(-1, 0));
  kthread_exit(42);
}

int main() {
  void *stack = malloc(STACK_SIZE);
  if (!stack) {
    printf("Failed to allocate stack\n");
    exit(1);
  }
  int tid = kthread_create(thread_func, stack, STACK_SIZE);
  if (tid < 0) {
    printf("kthread_create failed\n");
    exit(1);
  }
  int status = 0;
  int ret = kthread_join(tid, &status);
  if (ret == 0) {
    printf("Thread joined, exit status=%d\n", status);
  } else {
    printf("kthread_join failed\n");
  }
  free(stack);
  exit(0);
}
