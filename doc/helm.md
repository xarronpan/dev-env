# Heml Doc
https://helm.sh/docs/topics/charts/

# Heml Template
https://lzone.de/cheat-sheet/Helm%20Templates

# Helm commands
## Finding and viewing charts

### Add a remote chart repository
This adds a collection of charts called a repository. 
Repositories often contain many charts, and can be found on an open source repository server 
like Chartmuseum, or a public chart repository like ArtifactHub:
```bash
helm repo add [name] [url]
```
Example - using the Bitnami chart repository:
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```
### List all your repositories
You can see all of the repositories (the remote locations for downloading charts) 
that you have added to your helm installation:
```bash
$ helm repo list
NAME          URL
kedacore      https://kedacore.github.io/charts
stable        https://kubernetes-charts.storage.googleapis.com/
openfaas      https://openfaas.github.io/faas-netes/
jenkins       https://charts.jenkins.io
bitnami       https://charts.bitnami.com/bitnami
concourse     https://concourse-charts.storage.googleapis.com/
```
### Search for a chart
Using helm search will search either Artifact Hub (hub option) or 
all repositories configured on your system (repo option):
```bash
$ helm search hub prometheus
URL                                                 CHART VERSION   APP VERSION DESCRIPTION
https://hub.helm.sh/charts/prometheus-community...  12.0.1          2.21.0      Prometheus is a monitoring system and time seri...
...

$ helm search repo prometheus
NAME                                  CHART VERSION APP VERSION DESCRIPTION
bitnami/kube-prometheus               3.1.1         0.43.2      kube-prometheus collects Kubernetes manifests t...
bitnami/prometheus-operator           0.31.1        0.41.0      DEPRECATED The Prometheus Operator for Kubernet...
stable/prometheus                     11.9.1        2.19.0      Prometheus is a monitoring system and time seri...
```
### View information about a chart
To get information about a chart, or its values, use helm show, with chart or values:
```bash
$ helm repo add concourse https://concourse-charts.storage.googleapis.com/
$ helm show chart concourse/concourse
$ helm show values concourse/concourse
```

## Installing and managing charts
The most common way people make use of Helm is to find and install charts onto a Kubernetes cluster. 
Here are the main commands you might use when installing charts.

### Install a chart’s dependencies
If you have mentioned a dependency in your Chart.yaml, and you need to download it:
```bash
helm dependency update
```
### Simulate an install (dry-run)
To simulate installing a chart without actually installing it, do a dry run:
```bash
helm install --dry-run ...
```
NB: this does actually seem to interact with the Kubernetes API, to check if objects already exist in the cluster, etc. 
For a fully local rendering of a template, use helm template ... (see further below).

### Install a chart by reference from a repository
This will install a chart from a repository, so you should ensure that you’ve set up the repository first.
```bash
helm install myapp-instance sourcerepo/myapp
```
### Install a chart by reference with an explicit URL
This allows you to specify the URL to the repository when you install:
```bash
helm install --repo http://charts.example.com my-app-instance myapp
```
### Install a chart from a packaged file
```bash
helm install myapp-instance ./path/to/myappchart.tgz
```
### Install a chart from an unpacked chart directory
This is especially useful when you are developing a chart locally, or you have not published it to a chart repository.
```bash
helm install myapp-instance ./path/to/chart
```
### Install a template with a values override file
If you want to override the default values in the template with another values file, use -f:
```bash
helm install -f ./my-extra-values.yml ./mychart
```
Note that this will override default values where they are given, otherwise use the default values.

### Install a template with specific values
When you want to install a Helm chart, and override its values explicitly at the command line:
```bash
helm install --set key1=val1,key2=val2 [name] [chart]
```
Example, installing chart sourcerepo/myapp and overriding the property foo.bar:
```bash
helm install --set foo.bar=hello myapp-instance sourcerepo/myapp
```

## Getting information about deployed charts
### List all releases (deployed charts)
When you want to see all the charts that have been deployed on your cluster (releases):
```bash
helm list
```
### See all objects created by a release
When you want to get the YAML of all of the objects that comprise a release, 
or see all of the objects that were created when you did a helm install:
```bash
helm get manifest <release-name>
```
You’ll need to know the release name you’re looking for (you can list all releases using helm list).

### Print the status message of a release
When a chart is deployed (a release is created), a status message is shown. To print this message again:
```bash
helm status <release-name>
```

## Uninstalling a release
To uninstall a chart release from your cluster:
```bash
helm uninstall <release-name>
```

## Developing your own charts
Packaging your own software for use with Helm is known as creating a chart. 
You can create a chart yourself from scratch, or you can use the helm create chart which will initialise a chart for you.

### Creating a new chart
If you want to create your own chart:
```bash
helm create [path]
helm create mychart
```
This will create a new skeleton or boilerplate chart at ./mychart, which is ready for you to edit and customise.

### Locally render a chart template
Use helm template if you want Helm to show the output YAML from your Helm chart, 
if you were to helm install it. This is useful when debugging your chart:
```bash
helm template [NAME] [CHART]
helm template my-app-instance sourcerepo/my-app
helm template my-app-instance .
```
