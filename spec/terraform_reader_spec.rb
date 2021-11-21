require 'spec_helper'
# require_relative '../lib/'

RSpec.describe TerraformReader do
  describe '#read_member' do
    it 'Total members' do
      file_path = File.expand_path("#{__dir__}/fixtures/membership.tf")
      collaborator_file_path = File.expand_path("#{__dir__}/fixtures/repository_collaborator.tf")
      terraform_reader = TerraformReader.new(membership_file_path: file_path, repository_collaborator_file_path: collaborator_file_path)
      organization_member = terraform_reader.read_member

      expect(organization_member.total_member_count).to eq(7)
    end
  end
end
