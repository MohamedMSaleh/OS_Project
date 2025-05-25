# Fix for Thread Join Infinite Loop

## Problem Identified
While running the `kthread_edge` test, the system got stuck in an infinite loop with these messages:
```
[KTHREAD-KERNEL] kthread_join: waiting for tid=6
[KTHREAD-KERNEL] kthread_join: tid=6 not found or not in thread group
```

This happened because:
1. The `kthread_join` function was entering an infinite recursion loop when a thread was not found
2. There was no proper handling for threads that had already been joined (double join case)
3. Thread search logic didn't account for already cleaned-up threads

## Fix Applied (Updated)
Completely redesigned the `kthread_join` function in `kernel/proc.c` to:

1. Use an iterative approach with a while loop instead of recursion
2. Properly maintain lock handling throughout the loop
3. Use goto for clean exits from nested loops without releasing locks too early
4. Keep the same functionality for checking thread existence and thread group membership

```c
int kthread_join(int tid, int *status) {
  struct proc *p = myproc();
  struct proc *tp = 0;
  int found = 0;
  int has_been_joined = 0;
  int ret = -1;  // Default return value
  
  KTHREAD_DBG("kthread_join: waiting for tid=%d", tid);

  acquire(&wait_lock);
  
  // Loop until we either join the thread or determine it can't be joined
  while (1) {
    found = 0;
    has_been_joined = 0;
  
    // First check if this thread has already been joined
    for (tp = proc; tp < &proc[NPROC]; tp++) {
      if (tp->tid == tid && tp->is_thread && tp->state == UNUSED) {
        // Thread already joined
        has_been_joined = 1;
        break;
      }
    }
    
    if (has_been_joined) {
      KTHREAD_DBG("kthread_join: thread tid=%d already joined", tid);
      ret = -1;
      break;  // Exit the loop with failure
    }
    
    // Now try to find the thread
    for (tp = proc; tp < &proc[NPROC]; tp++) {
      if (tp->tid == tid && tp->is_thread) {
        acquire(&tp->lock);
        
        // Check if thread belongs to our thread group
        if (tp->tgid == p->tgid || tp->parent == p) {
          found = 1;
          
          if (tp->state == ZOMBIE) {
            KTHREAD_DBG("kthread_join: found zombie thread tid=%d", tid);
            if (status != 0) {
              *status = tp->xstate;
            }
            
            // Clean up the thread
            tp->state = UNUSED;
            freeproc(tp);
            
            release(&tp->lock);
            ret = 0;  // Success
            goto done;  // Exit both loops
          }
          
          release(&tp->lock);
          break; // Found a matching thread, break out of the search loop
        } else {
          release(&tp->lock);
        }
      }
    }
    
    if (!found) {
      KTHREAD_DBG("kthread_join: tid=%d not found or not in thread group", tid);
      ret = -1;
      break;  // Exit the loop with failure
    }
    
    // Wait for thread to exit - use a better sleep channel directly related to the tid
    uint64 channel = (uint64)tid;
    KTHREAD_DBG("kthread_join: sleeping waiting for tid=%d (channel=%lx)", tid, channel);
    sleep((void*)channel, &wait_lock);
    
    // After waking up, we loop again to check the thread's status
    // No need to release and reacquire wait_lock here
  }
  
done:
  release(&wait_lock);
  return ret;
}
```

## Impact of the Fix
- Thread joining correctly handles edge cases like double join and invalid TIDs
- Prevents the infinite loop previously seen in the logs
- Ensures threads that have already been joined are detected and handled properly
- Fixes potential memory leaks by ensuring thread resources are properly freed
