# kubequick
A bash script to list and use Kubernetes pods in your cluster. But quicker.


## What happens when I run this script?
1. Running the script will prompt you to enter a namespace or enter 'all' to get all pods in all namespaces. You can also use the default namespace by simply hitting enter on the first prompt.
2. The script will look through the selected namespace and return the pods with an associated number. 
3. Enter the number of the pod you want to use and hit enter.
4. The next prompt will ask if you want to "exec, logs, or describe" the pod. Type out one of the selections and hit enter for the action entered.
