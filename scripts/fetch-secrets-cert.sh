#!/bin/bash
kubeseal -n kube-system --fetch-cert > secretscert.pem
echo "Cert saved as: secretscert.pem"