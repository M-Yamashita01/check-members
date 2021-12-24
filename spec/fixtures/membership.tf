resource "github_membership" "membership_for_some_user1" {
  username = "SomeUser"
  role     = "member"
}
resource "github_membership" "membership_for_some_user2" {
  username = "SomeUser1"
  role     = "member"
}

resource "github_membership" "membership_for_some_user3" {
  username = "SomeUser2"
  role     = "member"
}

resource "github_membership" "membership_for_some_user4" {
  username = "SomeUser"
  role     = "member"
}
resource "github_membership" "membership_for_some_user5" {
  username = "SomeUser3"
  role     = "member"
}

resource "github_membership" "membership_for_some_user6" {
  username = "SomeUser2"
  role     = "member"
}