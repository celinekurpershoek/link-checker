workflow "Link check" {
  resolves = "linkcheck"
  on = "push"
}

action "linkcheck" {
  uses = "./.github/workflows/push.yml"
  args = "https://voorhoede.nl"
}
