kubectl describe quota --all-namespaces | grep "limits.cpu" | awk '{ sum += $3 } END { print sum }'
