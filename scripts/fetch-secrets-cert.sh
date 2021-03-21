#!/bin/bash
kubeseal --fetch-cert > secretscert.pem
echo "Cert saved as: secretscert.pem"