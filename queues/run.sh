#!/bin/bash

echo "Priority Queue: List Implementation"
(time racket priority/naive/queue-list.rkt) >/tmp/priq-list.out 2>&1

echo "Priority Queue: Sorted List Implementation"
(time racket priority/naive/queue-sortedlist.rkt) >/tmp/priq-sortedlist.out 2>&1

echo "Priority Queue: Binary Tree Implementation"
(time racket priority/performant/queue-binarytree.rkt) >/tmp/priq-btree.out 2>&1

echo "Priority Queue: Pairing Heap Implementation"
(time racket priority/performant/queue-pairingheap.rkt) >/tmp/priq-pairingheap.out 2>&1
