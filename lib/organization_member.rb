# frozen_string_literal: true

class OrganizationMembers
  def initialize(membership:, repository_collaborators:)
    @membership = membership
    @repository_collaborators = repository_collaborators
  end

  def total_members
    @membership.size + @repository_collaborators.size
  end
end
