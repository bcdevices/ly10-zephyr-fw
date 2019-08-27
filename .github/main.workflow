workflow "build-and-deploy" {
  on = "push"
  resolves = "deploy"
}

action "build" {
  uses = "./actions/action-zephyr"
}

action "deploy" {
  needs = "build"
  uses = "./actions/action-pltcloud"
  secrets = ["API_TOKEN", "PROJECT_UUID"]
}
