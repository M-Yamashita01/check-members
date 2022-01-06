resource "github_membership" "membership_for_some_user1" {
  username = "Membership1"
  role     = "member"
}
resource "github_membership" "membership_for_some_user2" {
  username = "Membership2"
  role     = "member"
}

resource "github_membership" "membership_for_some_user3" {
  username = "Membership3"
  role     = "member"
}

resource "github_membership" "membership_for_some_user4" {
  username = "Membership1"
  role     = "member"
}
resource "github_membership" "membership_for_some_user5" {
  username = "Membership4"
  role     = "member"
}

resource "github_membership" "membership_for_some_user6" {
  username = "Membership3"
  role     = "member"
}

resource "github_membership" "membership_for_some_user7" {}

resource "github_membership" "membership_for_some_user8" {
  role     = "member"
}

resource "a" {
  role = "member"
}