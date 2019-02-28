# An optimized version of the official kubecontext segment
function prompt_kube_context {
  local kubectl_version="$(kubectl version --client 2>/dev/null)"

  if [[ -n "$kubectl_version" ]]; then
    # Get the current Kuberenetes context
    local cur_ctx=$(kubectl config view -o=jsonpath='{.current-context}')
    "$1_prompt_segment" "$0" "$2" "magenta" "white" "$cur_ctx" "KUBERNETES_ICON"
  fi
}