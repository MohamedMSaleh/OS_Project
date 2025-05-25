// Simple user-space mutex using atomic exchange
#include "user/user.h"
#include "kernel/types.h"

typedef struct {
  volatile int locked;
} umutex_t;

void umutex_init(umutex_t *m) { m->locked = 0; }

// Improved mutex lock with memory barrier
void umutex_lock(umutex_t *m) {
  // Try to acquire the lock with exponential backoff strategy
  int backoff = 1;
  while (__sync_lock_test_and_set(&m->locked, 1) != 0) {
    // If we couldn't get it, use exponential backoff for contention management
    for (int i = 0; i < backoff; i++) {
      // CPU yield - compiler barrier
      __asm__ volatile("" ::: "memory");
    }
    
    // Double backoff time (capped at 1000 iterations)
    if (backoff < 1000)
      backoff *= 2;
  }
  
  // Full memory barrier - ensure all operations after the lock are not reordered before it
  __sync_synchronize();
}

// Improved mutex unlock with memory barrier
void umutex_unlock(umutex_t *m) {
  // Full memory barrier - ensure all operations before the unlock stay before it
  __sync_synchronize();
  
  // Release the lock - important to use lock_release not direct assignment
  __sync_lock_release(&m->locked);
}

#define NTHREADS 4
#define STACK_SIZE 4096
#define TIMEOUT_TICKS 10000000
volatile int shared = 0;
umutex_t mtx;

void thread_func(void) {
  for (int i = 0; i < 1000; i++) {
    umutex_lock(&mtx);
    shared++;
    umutex_unlock(&mtx);
  }
  kthread_exit(0);
}

int main() {
  printf("[main] Starting kthread_mutex\n");
  umutex_init(&mtx);
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
  printf("[main] Exiting kthread_mutex\n");
  exit(0);
}
