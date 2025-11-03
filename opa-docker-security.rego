package main


# 1. Block secrets in ENV keys
secrets_env = ["passwd", "password", "secret", "key", "token", "apikey"]
deny[msg] {
  input[i].Cmd == "env"
  val = lower(input[i].Value)
  contains(val, secrets_env[_])
  msg = sprintf("Line %d: Potential secret in ENV key: %s", [i, input[i].Value])
}


# 2. Trusted base images only (no slash)
deny[msg] {
  input[i].Cmd == "from"
  count(split(input[i].Value[0], "/")) > 1
  msg = sprintf("Line %d: Use a trusted base image", [i])
}


# 3. No 'latest' tags
deny[msg] {
  input[i].Cmd == "from"
  parts = split(input[i].Value[0], ":")
  contains(lower(parts[1]), "latest")
  msg = sprintf("Line %d: Do not use 'latest' tag for base images", [i])
}


# 4. Avoid curl/wget in RUN
deny[msg] {
  input[i].Cmd == "run"
  val = lower(concat(" ", input[i].Value))
  matches = regex.find_all("(curl|wget)[^ ]*", val, -1)
  count(matches) > 0
  msg = sprintf("Line %d: Avoid curl/wget in RUN", [i])
}


# 5. No system upgrades in RUN
upgrade_cmds = ["apk upgrade", "apt-get upgrade", "dist-upgrade"]
deny[msg] {
  input[i].Cmd == "run"
  val = lower(concat(" ", input[i].Value))
  contains(val, upgrade_cmds[_])
  msg = sprintf("Line %d: Do not upgrade system packages in Dockerfile", [i])
}


# 6. COPY not ADD
deny[msg] {
  input[i].Cmd == "add"
  msg = sprintf("Line %d: Use COPY instead of ADD", [i])
}


# 7. Must switch from root
any_user { input[i].Cmd == "user" }
deny[msg] {
  not any_user
  msg = "Use USER to switch from root"
}