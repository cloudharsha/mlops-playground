#!/usr/bin/env bash

set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-mlops-playground}"
KIND_NODE_IMAGE="${KIND_NODE_IMAGE:-}"

log() {
  printf '[setup-kind-cluster] %s\n' "$*"
}

die() {
  printf '[setup-kind-cluster] %s\n' "$*" >&2
  exit 1
}

require_commands() {
  local missing=()
  local cmd

  for cmd in docker kind; do
    if ! command -v "${cmd}" >/dev/null 2>&1; then
      missing+=("${cmd}")
    fi
  done

  if ((${#missing[@]} > 0)); then
    die "Missing required command(s): ${missing[*]}. Please install them and rerun the script."
  fi
}

check_docker() {
  if ! docker info >/dev/null 2>&1; then
    die "Docker is not reachable. Start Docker and rerun the script."
  fi
}

cluster_exists() {
  kind get clusters | grep -Fxq "${CLUSTER_NAME}"
}

create_cluster() {
  local kind_args=(create cluster --name "${CLUSTER_NAME}")

  if [[ -n "${KIND_NODE_IMAGE}" ]]; then
    kind_args+=(--image "${KIND_NODE_IMAGE}")
  fi

  log "Creating kind cluster ${CLUSTER_NAME}"
  kind "${kind_args[@]}"
}

print_next_steps() {
  printf '\n'
  log "Kind cluster ${CLUSTER_NAME} is ready"
  printf '  kubectl cluster-info --context kind-%s\n' "${CLUSTER_NAME}"
  printf '  kubectl get nodes --context kind-%s\n' "${CLUSTER_NAME}"
}

main() {
  require_commands
  check_docker

  if cluster_exists; then
    log "Kind cluster ${CLUSTER_NAME} already exists. Reusing it."
  else
    create_cluster
  fi

  print_next_steps
}

main "$@"
