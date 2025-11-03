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

############################
# 2. No latest tag for base images
############################
deny[msg] {
    some i
    input[i].Cmd == "from"
    parts := split(input[i].Value[0], ":")
    count(parts) > 1
    contains(lower(parts[1]), "latest")
    msg := sprintf("Line %d: Do not use 'latest' tag for base images", [i])
}

############################
# 3. Avoid curl/wget in RUN instructions
############################
deny[msg] {
    some i
    input[i].Cmd == "run"
    val := lower(concat(" ", input[i].Value))
    matches := regex.find_all("(curl|wget)[^ ]*", val, -1)
    count(matches) > 0
    msg := sprintf("Line %d: Avoid curl/wget in RUN", [i])
}

############################
# 4. Do not add secrets in ENV
############################
secrets_env := {"passwd", "password", "secret", "key", "token", "apikey"}

deny[msg] {
    some i
    input[i].Cmd == "env"
    val := lower(input[i].Value[0])
    some s
    s := secrets_env[_]
    contains(val, s)
    msg := sprintf("Line %d: Potential secret in ENV key: %s", [i, input[i].Value[0]])
}

############################
# 5. Use COPY instead of ADD
############################
deny[msg] {
    some i
    input[i].Cmd == "add"
    msg := sprintf("Line %d: Use COPY instead of ADD", [i])
}
