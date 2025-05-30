kubectl get nodes | grep NotReady | awk '{print $1}' | xargs -r kubectl delete node

helm list -A | grep demo-job-perlmutter | awk '{print $1, $2}' | while read release namespace; do helm uninstall "$release" -n "$namespace"; done