# FinPay Backend GitOps

Este repositório contém apenas o estado desejado do backend FinPay. A imagem da aplicação é produzida no repositório `finpay-backend`; este repositório não compila código nem aplica recursos diretamente no cluster. Depois que um Pull Request é aprovado e incorporado em `main`, o Argo CD pode observar essa revisão e reconciliá-la.

## Estrutura

```text
charts/finpay-backend/                 Helm Chart reutilizável
environments/development/values.yaml  Estado desejado de development
environments/production/values.yaml   Estado desejado de production
.github/workflows/deploy.yml          CD manual que propõe um Pull Request
```

O Chart cria um Deployment com uma réplica e um Service `ClusterIP` chamado exatamente `finpay-backend`, na porta 3000. As probes de readiness e liveness consultam `/api/health`. `APP_VERSION` recebe `image.tag` dos values.

## Versões e imagem imutável

- `Chart.yaml: version` versiona a estrutura e os templates do Chart, independentemente da aplicação.
- `Chart.yaml: appVersion` é apenas a versão padrão/documental da aplicação.
- `image.tag` registra a release promovida e configura `APP_VERSION`.
- `image.tag` define a imagem renderizada como `repository:tag` e registra a release promovida.

## CD manual

Em **Actions > Propose deployment > Run workflow**, informe:

- `environment`: `development` ou `production`;
- `release`: uma tag existente em `ghcr.io/vitorbalconi/finpay-backend`, como `1.0.0`.

O workflow valida os inputs, altera somente `environments/<environment>/values.yaml`, executa `helm lint` e `helm template` e abre um PR contra a `main` protegida. Se a tag já for a desejada, ele valida o Chart, mas não cria commit nem PR. Não há acesso a Kubernetes ou Argo CD.

O pacote GHCR é público, portanto nenhuma credencial de leitura é necessária. No repositório OPS, habilite **Settings > Actions > General > Workflow permissions > Allow GitHub Actions to create and approve pull requests**. O workflow concede ao `GITHUB_TOKEN` apenas `contents: write` e `pull-requests: write`; as regras de proteção e aprovação da `main` continuam valendo.

## Validação local

Com Helm 3 instalado:

```bash
helm lint charts/finpay-backend -f environments/production/values.yaml
helm template finpay-backend charts/finpay-backend -f environments/production/values.yaml
```
