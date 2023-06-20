#!/bin/bash

for i in {1..20}; do
    echo "Ensuring that containers are spawned... ${i}"
    count=$(oc get pods --all-namespaces | grep openshift | grep -vic 'running')
    if [ "$count" -eq "0" ]; then
        # Ensure that all pods are in expected count
        for ns in $(oc get pods --all-namespaces | grep openshift | awk '{print $1}'); do
            echo "Checking pods from namespace: $ns";
            if ! kubectl -n "$ns" wait --for=condition=Ready pod --all; then
                echo -e "\nThe namespace $ns pods count does not match. Waiting..."
                sleep 15
            fi
        done
        echo -e "\nMicroshift is deployed, we can continue..."
        break
    else
        echo "The Microshift containers are not ready..."
        sleep 15
    fi
done
