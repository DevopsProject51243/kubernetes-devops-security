package docker.security

############################
# 1. Do not run as root
############################
deny[msg] {
    not any_user
    msg := "Use USER to switch from root"
}

any_user {
    some i
    input[i].Cmd == "user"
}
