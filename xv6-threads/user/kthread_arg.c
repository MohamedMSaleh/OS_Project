// Thread with argument passing (bonus/creative)
#include "user/user.h"
#include "kernel/types.h"
#define STACK_SIZE 4096

struct arg {
  int value;
};

void thread_func(void *arg) {
  struct arg *a = (struct arg*)arg;
  printf("Thread got arg: %d\n", a->value);
  kthread_exit(a->value + 1);
}

int main() {
  void *stack = malloc(STACK_SIZE);
  struct arg a = { .value = 99 };
  // Cast function and pass pointer as stack base (demo only)
  int tid = kthread_create((void(*)())thread_func, stack, STACK_SIZE);
  // Place arg at bottom of stack
  *(struct arg*)stack = a;
  int status = 0;
  kthread_join(tid, &status);
  printf("Thread returned: %d\n", status);
  free(stack);
  exit(0);
}
