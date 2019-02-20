Flux CD
-------

This github action copies your kubernetes manifests to the underarmour flux repository

## Convention Over Configuration

The tool is built on convention over configuration so in your repository you need to have certain filepaths and these will be copied over to the flux repo if they exists with the following

LOCAL REPO PATH -> FLUX REPO PATH
- `kubernetes/global` -> `global/automated/$GITHUB_REPOSITORY_NAME`
- `kubernetes/us` -> `us/automated/$GITHUB_REPOSITORY_NAME`
- `kubernetes/china` -> `tokyo/automated/$GITHUB_REPOSITORY_NAME`

## Setup

To configure this action on your github repository you need to do the follow:

1. Have a github workflow defined in your project - `./.github/main.workflow`
2. Add the following as an action and place it in your resolves list for you workflow. Example:
```
workflow "CD" {
  on = "push"
  resolves = ["flux-cd"]
}

action "flux-cd" {
  uses = "underarmour/github-actions/flux-cd@master"
  secrets = ["GIT_PASSWORD"]
}
```
  NOTE: the script only lets commits to your repos 'master' branch get copied to the flux repo
  
3. Retrieve the Github bot password from [vault](https://vault.uacf.io/ui/vault/secrets/secret/show/jenkins/github) at the location `secret/jenkins/github`
4. Add a github secret to your project https://github.com/underarmour/{YOUR_REPO_NAME}/settings/secrets 
![secret image example](./Secret.png)
5. Commit the changes to your repo.
6. Profit - you're kubernetes manifests will end up in the [flux repo](https://github.com/underarmour/flux-kubernetes)
