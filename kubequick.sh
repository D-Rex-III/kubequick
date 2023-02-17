#!/bin/bash

echo "Enter namespace (Enter 'all' for all namespaces): "
read -r -e -p "" namespace

if [ -z "$namespace" ]; then
    namespace="default"
    namespaces=("$namespace")
    NAMESPACE_FLAG="-n $namespace"
    pods=($(kubectl get pods $NAMESPACE_FLAG 2>/dev/null | awk '{print $1}' | tail -n +2))
elif [ "$namespace" = "all" ]; then
    NAMESPACE_FLAG="--all-namespaces"
    namespaces=($(kubectl get pods $NAMESPACE_FLAG 2>/dev/null | awk '{print $1}' | tail -n +2))
    pods=($(kubectl get pods $NAMESPACE_FLAG 2>/dev/null | awk '{print $2}' | tail -n +2))
else
    NAMESPACE_FLAG="-n $namespace"
    namespaces=("$namespace")
    pods=($(kubectl get pods $NAMESPACE_FLAG 2>/dev/null | awk '{print $1}' | tail -n +2))
fi

if [ ${#pods[@]} -eq 0 ]; then
    echo "Can not find namespace: $namespace"
    exit 1
fi

if [ "$namespace" = "all" ]; then
    for name_count in "${!pods[@]}"; do
        echo "$name_count: ${namespaces[$name_count]}/${pods[$name_count]}"
    done
else
    for name_count in "${!pods[@]}"; do
        echo "$name_count: ${namespace}/${pods[$name_count]}"
    done
fi

while true; do
    read -r -p "Enter the number of the pod you want to select: " pod_num
    if [[ ! $pod_num =~ ^[0-9]+$ ]] || [ "$pod_num" -lt 0 ] || [ "$pod_num" -ge ${#pods[@]} ]; then
        echo "Invalid input. Please enter a valid number."
    else
        break
    fi
done

selected_namespace=${namespaces[pod_num]}
selected_pod=${pods[pod_num]}

while true; do
    read -r -p "Choose action for pod: $selected_pod? (exec, logs, describe): " action
    if [ "$action" == "exec" ]; then
        read -r -p "Enter the shell to exec into the pod [sh or bash]: " shell
        shell=${shell:-sh}
        kubectl -n "$selected_namespace" exec -it "$selected_pod" -- "$shell" || echo "Error executing kubectl exec command."
        break
    elif [ "$action" == "logs" ]; then
        kubectl -n "$selected_namespace" logs "$selected_pod" || echo "Error executing kubectl logs command."
        break
    elif [ "$action" == "describe" ]; then
        kubectl -n "$selected_namespace" describe pod "$selected_pod" || echo "Error executing kubectl describe command."
        break
    else
        echo "Invalid action, please enter a valid action (exec, logs, describe)."
    fi
done
