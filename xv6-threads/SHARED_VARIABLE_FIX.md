# Shared Variable Synchronization Fix

## Problem

In the multi-threaded tests (kthread_many and kthread_mutex), the shared variable was not being properly updated, showing a value of 0 at the end of execution when it should have been 4000 (4 threads × 1000 increments).

## Cause Analysis

1. **Race Conditions**: Multiple threads were trying to increment the same memory location without proper synchronization.

2. **Cache Coherency Issues**: Even with atomic operations, CPU caches might not have been properly synchronized.

3. **Memory Ordering Problems**: Without proper memory barriers, operations might have been reordered by the processor or compiler.

4. **Compiler Optimizations**: The compiler might have optimized out some operations on the shared variable.

5. **High Contention**: Threads might have been interfering with each other, causing some increments to be lost due to high contention.

## Fixes Applied

### For kthread_many.c

1. **Declared shared variable as volatile**:
   ```c
   volatile int shared = 0;
   ```
   This prevents the compiler from optimizing out operations on this variable.

2. **Used proper atomic increment with memory barriers**:
   ```c
   __sync_fetch_and_add(&shared, 1);
   ```
   This ensures that the increment operation is atomic and includes necessary memory barriers.

3. **Added a small delay between increments**:
   ```c
   for (int j = 0; j < 10; j++) {
     __asm__ volatile("" ::: "memory");
   }
   ```
   This reduces contention between threads and forces the compiler to respect memory ordering.

### For kthread_mutex.c

1. **Improved mutex implementation with exponential backoff**:
   ```c
   void umutex_lock(umutex_t *m) {
     int backoff = 1;
     while (__sync_lock_test_and_set(&m->locked, 1) != 0) {
       for (int i = 0; i < backoff; i++) {
         __asm__ volatile("" ::: "memory");
       }
       if (backoff < 1000)
         backoff *= 2;
     }
     __sync_synchronize();
   }
   ```
   This reduces contention by having threads wait exponentially longer when the lock is busy.

2. **Added proper memory barriers in mutex operations**:
   ```c
   void umutex_unlock(umutex_t *m) {
     __sync_synchronize();
     __sync_lock_release(&m->locked);
   }
   ```
   Full memory barriers ensure operations are properly ordered before releasing the lock.

3. **Improved thread function to use local counter**:
   ```c
   void thread_func() {
     int local_count = 0;
     for (int i = 0; i < 1000; i++) {
       umutex_lock(&mtx);
       shared++;
       local_count++;
       umutex_unlock(&mtx);
     }
     printf("[thread_func] Thread incremented shared %d times, current value: %d\n", 
            local_count, shared);
   }
   ```
   This helps track if all increments are actually being performed.

## Results

After applying these fixes:
1. The kthread_many test now correctly shows shared=4000 after all threads join.
2. The kthread_mutex test properly synchronizes access to the shared variable.
3. Race conditions and lost updates have been eliminated.

## Key Lessons

1. Always use atomic operations for shared variable access in multi-threaded code.
2. Declare shared variables as volatile to prevent compiler optimizations.
3. Use memory barriers to ensure proper memory ordering.
4. Implement backoff strategies to reduce contention in synchronization primitives.
5. Consider using local counters to track and verify operations in multi-threaded code.
