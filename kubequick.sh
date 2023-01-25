#!/bin/bash

echo "Enter namespace (default for default namespace): "
read namespace

if [ -z "$namespace" ]; then
    namespace="default"
fi

pods=($(kubectl get pods -n $namespace 2>/dev/null | awk '{print $1}' | tail -n +2))

if [ ${#pods[@]} -eq 0 ]; then
    echo "No pods found in namespace $namespace"
    exit 1
fi

for i in "${!pods[@]}"; do
    echo "$i: ${pods[i]}"
done

echo "Enter the number of the pod you want to select: "
read pod_num

if [ $pod_num -lt 0 ] || [ $pod_num -ge ${#pods[@]} ]; then
    echo "Invalid input. Please enter a valid number."
    exit 1
fi

selected_pod=${pods[pod_num]}

echo "What would you like to do with the selected pod? (exec, logs, describe)"
read action

if [ $action == "exec" ]; then
    echo "Enter the shell to exec into the pod (sh or bash): "
    read shell

    if [ -z "$shell" ]; then
        shell="sh"
    fi
    kubectl -n $namespace exec -it $selected_pod -- $shell
elif [ $action == "logs" ]; then
    kubectl -n $namespace logs $selected_pod
elif [ $action == "describe" ]; then
    kubectl -n $namespace describe pod $selected_pod
else
    echo "Invalid action, please enter a valid action (exec, logs, describe)"
fi
