package k8s.security


deny[msg] {
  input.kind == "Pod"
  not input.spec.securityContext.runAsNonRoot
  msg = "Pods must set securityContext.runAsNonRoot = true"
}