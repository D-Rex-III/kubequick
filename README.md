# kubequick
A bash script to check a Kubernetes namespace for pods and quickly select a pod to exec into.


## What happens when I run this script?
1. Running the script will prompt you to enter a namespace or hit enter for default namespace.
2. The script will look through the namespace and return the pods with an associated number. 
3. Enter the number of the pod you want to use and hit enter.
4. The next prompt will ask if you want to "exec, logs, or describe" the pod. Type out one of the selections and hit enter.
