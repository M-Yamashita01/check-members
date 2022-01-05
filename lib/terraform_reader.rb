# frozen_string_literal: true
require_relative 'organization_member'

class TerraformReader
  def initialize(membership_file_path:, repository_collaborator_file_path:)
    @membership_file_path = membership_file_path
    @repository_collaborator_file_path = repository_collaborator_file_path
  end

  def read_member
    organization_members = extract_members(file_path: @membership_file_path)
    collaborator_members = extract_members(file_path: @repository_collaborator_file_path)

    OrganizationMembers.new(membership: organization_members, repository_collaborators: collaborator_members)
  end

  private

  def extract_members(file_path:)
    file = open_file(file_path: file_path)
    organization_members = []
    lines = except_comment_lines(file: file)
    lines.each do |line|
      splits = line.split(' ')
      # Consider the case of ["Username", "=", "\"Someuser\""]
      organization_members << splits[2] if splits.include?('username')
    end

    organization_members.uniq
  end

  def except_comment_lines(file:)
    lines = file.readlines
    excepted_multiline_comments_lines = except_multiline_comments(lines: lines)
    excepted_single_comments(lines: excepted_multiline_comments_lines)
  end

  def except_multiline_comments(lines:)
    loop do
      start_index = lines.find_index { |line| line.start_with?('/*') }
      break if start_index.nil?

      end_index = lines.find_index { |line| line.start_with?('*/') }
      end_index = lines.size - 1 if end_index.nil?

      (end_index - start_index + 1).times do
        lines.delete_at(start_index)
      end
    end

    lines
  end

  def excepted_single_comments(lines:)
    lines.reject do |line|
      line.start_with?('#') || line.start_with?('//')
    end
  end

  def open_file(file_path:)
    File.open(file_path)
  end
end
