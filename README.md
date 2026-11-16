# Infrastruktura

OpenTofu stawia lokalnie bucket S3 i klaster EKS na [Floci](https://floci.io/). Floci udaje AWS na `http://localhost:4566`, a klaster EKS to kontener k3s.

OpenTofu kończy się na klastrze. Nie tworzy Deploymentów, obrazów ani Argo CD. `tofu destroy` kasuje cały kontener k3s, więc wszystko, co zostało dołożone ręcznie albo przez GitOps, znika razem z nim.

## Co powstaje

Przy `environment = local` i `enable_eks = true`:

| Zasób               | Nazwa                              | Po co                                                           |
| ------------------- | ---------------------------------- | --------------------------------------------------------------- |
| Bucket S3           | `platforma-local`                  | Pliki. We Floci to lokalna atrapa.                              |
| Rola IAM            | `platforma-local-cluster`          | Floci odrzuca `CreateCluster`, jeśli rola jeszcze nie istnieje. |
| VPC i dwie podsieci | `10.0.0.0/16`, strefy `a` i `b`    | Provider `aws_eks_cluster` wymaga podsieci. Sieć jest pusta.    |
| Klaster EKS         | `platforma-local`, Kubernetes 1.31 | API na `https://localhost:<port>` (zakres 6500–6599).           |

Na `dev` klaster jest wyłączony (`enable_eks = false`), żeby apply nie zakładał prawdziwego EKS w AWS.

## Narzędzia

Wersje trzyma [mise](https://mise.jdx.dev/), plik `mise.toml`: OpenTofu i AWS CLI. Dodatkowo potrzebne są Docker, `kubectl` i działający daemon Dockera. Floci w trybie realnym uruchamia k3s przez socket Dockera.

```bash
mise install
```

## Floci

Emulator leży w repozytorium backendu: `backend/infra-local-emulator`.

```bash
cd ../backend/infra-local-emulator
docker compose up -d
```

Compose publikuje port `4566` i montuje `/var/run/docker.sock`. Bez socketa Floci nie wystartuje kontenera k3s.

## Plik środowiska

`infra/envs/*.tfvars` jest w `.gitignore`. Lokalny plik wygląda tak:

```hcl
environment        = "local"
project            = "platforma"
aws_region         = "eu-central-1"
force_destroy      = true
aws_s3_endpoint    = "http://localhost:4566"
s3_use_path_style  = true
skip_aws_checks    = true
aws_access_key     = "test"
aws_secret_key     = "test"
enable_eks         = true
kubernetes_version = "1.31"
```

`test` / `test` to publiczna para Floci do wywołań API (S3, IAM, EKS). Nie nadaje się do `kubectl`. Webhook klastra odrzuca ją, bo dostałaby uprawnienie `cluster-admin`.

## Apply

Z katalogu `infra`, albo taskiem VS Code **Deploy infrastructure** (wybór `local` albo `dev`):

```bash
cd infra
mise exec -- tofu init
mise exec -- tofu apply -var-file=envs/local.tfvars
```

Po apply output `cluster_endpoint` pokazuje adres API, zwykle `https://localhost:6500`. Output `update_kubeconfig` to polecenie, które zapisuje ten adres w kubeconfigu.

## kubectl

Najpierw użytkownik IAM we Floci. Klucze `test` / `test` służą tylko do tego wywołania:

```bash
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=eu-central-1
export AWS_ENDPOINT_URL=http://localhost:4566

mise exec -- aws iam create-user --user-name kubectl
mise exec -- aws iam create-access-key --user-name kubectl
```

`AccessKeyId` i `SecretAccessKey` z odpowiedzi podmieniają zmienne. `AWS_ENDPOINT_URL` zostaje, bo `kubectl` odpala `aws eks get-token`, a ten proces musi trafić do Floci, nie do prawdziwego AWS.

```bash
export AWS_ACCESS_KEY_ID="<AccessKeyId>"
export AWS_SECRET_ACCESS_KEY="<SecretAccessKey>"

mise exec -- aws eks update-kubeconfig --name platforma-local --region eu-central-1
kubectl get nodes
```

## Argo CD

Instalacja jest ręczna. OpenTofu jej nie śledzi.

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Panel na localhost:

```bash
kubectl port-forward -n argocd svc/argocd-server 8080:80
```

UI: [http://localhost:8080](http://localhost:8080). Login to `admin`. Hasło:

```bash
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Manifesty aplikacji trzymaj w gicie (katalog `cluster/` jest na to pusty). Argo CD synchronizuje je do klastra. Zmiana obrazu to commit, nie `tofu apply`.

## Destroy

Task **destroy infrastructure** kasuje bucket i klaster. Sam klaster, bez bucketa:

```bash
cd infra
mise exec -- tofu destroy -target=module.eks -var-file=envs/local.tfvars
```

`DeleteCluster` zatrzymuje kontener k3s. Argo CD i zsynchronizowane aplikacje giną razem z nim. Przy następnym apply klaster jest pusty i Argo CD trzeba zainstalować od nowa.
