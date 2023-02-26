# Source: https://gist.github.com/9e5864c5f9e79d34dadc57c700f5ec5e

######################################################################
# Garden - Build, Deploy, And Test Cloud And Kubernetes Applications #
# https://youtu.be/BUlrbSxpRTs                                       #
######################################################################

# Additional Info:
# - Garden: https://garden.io
# - Skaffold - How to Build and Deploy In Kubernetes: https://youtu.be/qS_4Qf8owc0
# - DevSpace - Development Environments in Kubernetes: https://youtu.be/nQly_CEjJc4
# - Development Environments Made Easy With Tilt Rebuilds And Live Updates: https://youtu.be/fkODRlobR9I
# - Should We Replace Docker Desktop With Rancher Desktop?: https://youtu.be/bYVfCp9dRTE

#########
# Setup #
#########

git clone https://github.com/vfarcic/garden-demo

cd garden-demo

# This demo was tested on Rancher Desktop with `dockerd` (not `nerdctl`) as container runtime, but it should work with any Kubernetes cluster.
# Please watch https://youtu.be/bYVfCp9dRTE if you are not familiar with Rancher Desktop

# Start local Kuberentes cluster using Rancher Desktop.
# Some commands and manifests might need to be modified if you're using a different local Kubernetes cluster.

# Install the CLI using the instructions from https://docs.garden.io/getting-started/1-installation

rm project.garden.yml \
  garden.yml

# If not using Rancher Desktop, replace `127.0.0.1` with the base host accessible through Ingress
export LOCAL_INGRESS_HOST=127.0.0.1

yq --inplace \
    ".environments[0].variables.hostname = \"garden-demo.$LOCAL_INGRESS_HOST.nip.io\"" \
    project.garden.yml.orig

################
# Garden Setup #
################

garden create project

cat project.garden.yml

cat project.garden.yml.orig

cp project.garden.yml.orig \
    project.garden.yml

garden create module \
    --name silly-demo \
    --skip-comments

# Choose `container`

cat garden.yml

garden deploy

#################################################
# Deploying Kubernetes Applications With Garden #
#################################################

cat garden.yml.orig

cp garden.yml.orig garden.yml

garden deploy

kubectl --namespace garden-demo-my-app \
    get all,ingresses

kubectl --namespace garden-demo-my-app \
    get deployment backend --output yaml

echo "http://garden-demo.$LOCAL_INGRESS_HOST.nip.io"

# Open it in a browser

garden delete environment

cat garden.yml.k8s

cp garden.yml.k8s garden.yml

garden deploy

garden deploy

garden delete environment

cp garden.yml.orig garden.yml

######################################
# Continuous Deployments With Garden #
######################################

garden deploy --help

garden deploy --env local --watch

# Change the source code

# Reload browser

# Press `ctrl+c`

# garden deploy --env prod

#####################################
# Testing And Workflows With Garden #
#####################################

cat garden.yml.tests

cp garden.yml.tests garden.yml

garden deploy

garden test

cat workflows.garden.yml

garden run workflow my-workflow

##################
# Garden Pricing #
##################

# Open https://garden.io/pricing

kubectl get namespaces

kubectl --namespace garden-system \
    get all

kubectl --namespace garden-system \
    get configmaps