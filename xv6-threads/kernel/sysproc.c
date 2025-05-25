#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

// Remove prototype for kthread_dbg since it's not used

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_kthread_create(void)
{
  uint64 start_func;
  uint64 stack;
  uint64 stack_size;
  argaddr(0, &start_func);
  argaddr(1, &stack);
  argaddr(2, &stack_size);
  // Comment out kthread_dbg calls to fix linker error
  // kthread_dbg("sys_kthread_create: start_func=%p, stack=%p, stack_size=%d\n", start_func, stack, stack_size);
  return kthread_create((void (*)())start_func, (void *)stack, stack_size);
}

uint64
sys_kthread_exit(void)
{
  int status;
  argint(0, &status);
  // kthread_dbg("sys_kthread_exit: status=%d\n", status);
  kthread_exit(status);
  return 0; // not reached
}

uint64
sys_kthread_join(void)
{
  int tid;
  uint64 status_addr;
  argint(0, &tid);
  argaddr(1, &status_addr);
  // kthread_dbg("sys_kthread_join: tid=%d, status_addr=%p\n", tid, status_addr);
  int status;
  int ret = kthread_join(tid, &status);
  if (ret == 0) {
    copyout(myproc()->pagetable, status_addr, (char *)&status, sizeof(int));
  }
  return ret;
}
