data "gitlab_group" "gitops-demo-apps" {
  full_path = "gitops-demo/apps"
}

provider "gitlab" {
  alias   = "use-pre-release-plugin"
  version = "v2.99.0"
}
resource "gitlab_group_cluster" "gke_cluster" {
  provider           = "gitlab.use-pre-release-plugin"
  group              = "${data.gitlab_group.gitops-demo-apps.id}"
  name               = "${google_container_cluster.primary.name}"
  domain             = "dev.gitops-demo.com"
  environment_scope  = "dev/"
  kubernetes_api_url = "${google_container_cluster.primary.endpoint}"
  kubernetes_token   = "${data.kubernetes_secret.gitlab-admin-token.data.token}"
  kubernetes_ca_cert = "${trimspace(base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate))}"

}