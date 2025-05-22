// Simple test for kernel threads in XV6
#include "user/user.h"
#include "kernel/types.h"
#include "kernel/param.h"

#define STACK_SIZE 4096

void thread_func() {
  printf("[thread_func] Thread running!\n");
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
    printf("[main] Thread joined, exit status: %d\n", status);
  } else {
    printf("[main] kthread_join failed\n");
  }
  free(stack);
  exit(0);
}
