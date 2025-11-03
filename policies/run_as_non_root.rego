package k8s.security

deny[msg] {
  if input.kind == "Pod" {
    if not input.spec.securityContext.runAsNonRoot {
      msg = "Pods must set securityContext.runAsNonRoot = true"
    }
  }
}