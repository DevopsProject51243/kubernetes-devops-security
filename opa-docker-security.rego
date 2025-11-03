package commands
import rego.v1
package main

denylist := [
	"apk",
	"apt",
	"pip",
	"curl",
	"wget",
]

deny contains msg if {
	some i
	input[i].Cmd == "run"
	val := input[i].Value
	contains(val[_], denylist[_])

	msg := sprintf("unallowed commands found %s", [val])
}

denylist := ["openjdk"]

deny contains msg if {
	some i
	input[i].Cmd == "from"
	val := input[i].Value
	contains(val[i], denylist[_])

	msg = sprintf("unallowed image found %s", [val])
}