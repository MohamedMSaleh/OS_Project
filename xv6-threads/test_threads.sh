#!/bin/sh
# Test script for XV6 thread implementation
# Runs all thread test programs sequentially

echo "Running XV6 Thread Tests"
echo "-----------------------"

echo "Test 1: Basic Thread Test"
kthreadtest
echo ""

echo "Test 2: Multiple Threads with Shared Variable"
kthread_many
echo ""

echo "Test 3: Thread Mutex Synchronization"
kthread_mutex
echo ""

echo "Test 4: Thread Edge Cases (Double Join, Invalid Join)"
kthread_edge
echo ""

echo "Test 5: Thread Argument Passing"
kthread_arg
echo ""

echo "All tests completed!"
