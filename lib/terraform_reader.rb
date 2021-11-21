require 'organization_member'

class TerraformReader
  def initialize(membership_file_path:, repository_collaborator_file_path:)
    @membership_file_path = membership_file_path
    @repository_collaborator_file_path = repository_collaborator_file_path
  end

  def read_member
    organization_members = extract_members(file_path: @membership_file_path)
    collaborator_members = extract_members(file_path: @repository_collaborator_file_path)

    OrganizationMembers.new(memberships: organization_members, repository_collaborators: collaborator_members)
  end

  private

  def extract_members(file_path:)
    file = open_file(file_path: file_path)
    organization_members = []
    file.each do |line|
      splits = line.split(' ')
      # ["username", "=", "\"SomeUser\""]の場合を考える
      organization_members << splits[2] if splits.include?('username')
    end

    organization_members.uniq
  end

  def open_file(file_path:)
    File.open(file_path)
  end
end
