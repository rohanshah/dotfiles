## Google Cloud cluster access (adds the cluster to kubectx)
gcloud container clusters get-credentials <cluster-name> --region us-east1 --project <project-name>

## Logging from pod
kubectl logs -n <namespace> -f <pod-name>

## Re-run cronjob
kubectl -n <namespace> create job --from=cronjob/<pod-name> <pod-name>-<timestamp>-random-four-digits

## Port forwarding
kubectl -n <namespace> port-forward <pod-name> <local-port>:<pod-port>

## Get secret
kubectl -n <namespace> get secret <secret-name> -o jsonpath="{.data.PASSWORD}" | base64 --decode
kubectl --context=<google-cloud-context> -n <namespace> exec -it <pod-name> -c <container-name> -- cat /vault/secrets/app-secrets.env

## Get environment variables
kubectl -n <namespace> exec -it <pod-name> -- env

## Connect to pod
kubectl-n <namespace> exec --stdin --tty <pod> /bin/bash

## Switch environments
kubectl config get-contexts
kubectl config use-context <CONTEXT>

## Connect to CockroachDB
https://github.com/cockroachdb/cockroach-operator#access-the-sql-shell

kubectl create -f https://raw.githubusercontent.com/cockroachdb/cockroach-operator/master/examples/client-secure-operator.yaml
kubectl exec -it cockroachdb-client-secure -c cockroachdb-client-secure -- ./cockroach sql --certs-dir=/cockroach/cockroach-certs --host=cockroachdb-public

## Copy directory contents off of pod
kubectl cp <pod-name>:<directory-on-pod> <local-directory> -c <container-name>  -n <namespaec>
