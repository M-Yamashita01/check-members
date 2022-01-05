# frozen_string_literal: true

class OrganizationMembers
  def initialize(membership_usernames:, repository_collaborator_usernames:)
    @membership_usernames = membership_usernames
    @repository_collaborator_usernames = repository_collaborator_usernames
  end

  def total_members
    @membership_usernames.size + @repository_collaborator_usernames.size
  end
end
