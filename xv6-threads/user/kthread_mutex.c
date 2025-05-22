// Simple user-space mutex using atomic exchange
#include "user/user.h"
#include "kernel/types.h"

typedef struct {
  volatile int locked;
} umutex_t;

void umutex_init(umutex_t *m) { m->locked = 0; }
void umutex_lock(umutex_t *m) {
  while (__sync_lock_test_and_set(&m->locked, 1)) {}
}
void umutex_unlock(umutex_t *m) { m->locked = 0; }

#define NTHREADS 4
#define STACK_SIZE 4096
int shared = 0;
umutex_t mtx;

void thread_func() {
  for (int i = 0; i < 1000; i++) {
    umutex_lock(&mtx);
    shared++;
    umutex_unlock(&mtx);
  }
  kthread_exit(0);
}

int main() {
  umutex_init(&mtx);
  int tids[NTHREADS];
  void *stacks[NTHREADS];
  for (int i = 0; i < NTHREADS; i++) {
    stacks[i] = malloc(STACK_SIZE);
    tids[i] = kthread_create(thread_func, stacks[i], STACK_SIZE);
  }
  for (int i = 0; i < NTHREADS; i++) {
    kthread_join(tids[i], 0);
    free(stacks[i]);
  }
  printf("[main] All threads joined. shared=%d (should be %d)\n", shared, NTHREADS*1000);
  exit(0);
}
