# kubequick
A bash script to check a Kubernetes namespace for pods and quickly select a pod to exec into.

Running the script will prompt you to enter a namespace or hit enter for default namespace.
The script will look through the namespace and return the pods with an associated number. Enter the number of the pod you want and hit enter
The next prompt will ask if you want to exec, logs, or describe the pod. Type out one of the selections and hit enter.
