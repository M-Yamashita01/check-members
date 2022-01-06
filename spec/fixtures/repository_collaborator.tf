resource "github_repository_collaborator" "a_repo_collaborator1" {
  repository = "our-cool-repo"
  username   = "RepositoryCollaborator1"
  permission = "admin"
}

resource "github_repository_collaborator" "a_repo_collaborator2" {
  repository = "our-cool-repo"
  username   = "RepositoryCollaborator3"
  permission = "admin"
}

resource "github_repository_collaborator" "a_repo_collaborator3" {
  repository = "our-cool-repo"
  username   = "RepositoryCollaborator4"
  permission = "admin"
}

resource "github_repository_collaborator" "a_repo_collaborator4" {
  repository = "our-cool-repo"
  username   = "RepositoryCollaborator1"
  permission = "admin"
}

resource "github_repository_collaborator" "a_repo_collaborator5" {
  repository = "our-cool-repo"
  username   = "RepositoryCollaborator3"
  permission = "admin"
}

/*
resource "github_repository_collaborator" "a_repo_collaborator" {
  repository = "our-cool-repo"
  username   = "CommentOutUser1"
  permission = "admin"
}

resource "github_repository_collaborator" "a_repo_collaborator" {
  repository = "our-cool-repo"
  username   = "CommentOutUser3"
  permission = "admin"
}
*/

# resource "github_repository_collaborator" "a_repo_collaborator" {
#   repository = "our-cool-repo"
#   username   = "CommentOutUser4"
#   permission = "admin"
# }

// resource "github_repository_collaborator" "a_repo_collaborator" {
//  repository = "our-cool-repo"
//  username   = "CommentOutUser5"
//  permission = "admin"
//}

/*
resource "github_repository_collaborator" "a_repo_collaborator" {
  repository = "our-cool-repo"
  username   = "CommentOutUser6"
  permission = "admin"
}

resource "github_repository_collaborator" "a_repo_collaborator" {
  repository = "our-cool-repo"
  username   = "CommentOutUser7"
  permission = "admin"
}
*/