#!/bin/bash


# Run specific Kubelet tests
total_fail=$(kube-bench node \
  --version 1.15 \
  --check 2.1.2,2.1.3 \
  --json | jq -r '.[].total_fail')


if [[ "$total_fail" -ne 0 ]]; then
  echo "CIS Benchmark Failed: Kubelet checks 2.1.2,2.1.3"
  exit 1
else
  echo "CIS Benchmark Passed: Kubelet checks 2.1.2,2.1.3"
fi