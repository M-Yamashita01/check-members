# frozen_string_literal: true

class OrganizationMembers
  def initialize(memberships:, repository_collaborators:)
    @memberships = memberships
    @repository_collaborators = repository_collaborators
  end

  def total_member_count
    @memberships.size + @repository_collaborators.size
  end
end
