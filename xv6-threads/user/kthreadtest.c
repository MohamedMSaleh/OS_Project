// Simple test for kernel threads in XV6
#include "user/user.h"
#include "kernel/types.h"
#include "kernel/param.h"
#include "kernel/fcntl.h"
#include "kernel/stat.h"

#define STACK_SIZE 4096
#define TIMEOUT_TICKS 10000000
#define KTHREAD_DBG(fmt, ...) printf("[kthread-user] " fmt "\n", ##__VA_ARGS__)

void thread_func(void) {
    KTHREAD_DBG("thread_func: started");
    printf("[thread_func] Thread running!\n");
    KTHREAD_DBG("thread_func: finishing");
    kthread_exit(42);
}

int main(void) {
    KTHREAD_DBG("main: Starting kthreadtest");
    void *stack = malloc(STACK_SIZE);
    if (!stack) {
        printf("Failed to allocate stack\n");
        exit(1);
    }
    
    int tid = kthread_create(thread_func, stack, STACK_SIZE);
    KTHREAD_DBG("main: kthread_create returned tid=%d", tid);
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
    KTHREAD_DBG("main: kthread_join returned");
    printf("[main] Exiting kthreadtest\n");
    exit(0);
}
