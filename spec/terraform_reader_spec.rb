# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TerraformReader do
  describe '#read_members' do
    it 'Total members' do
      terraform_directory_path = File.expand_path("#{__dir__}/fixtures")
      terraform_reader = TerraformReader.new(terraform_directory_path: terraform_directory_path)
      organization_member = terraform_reader.read_members
      expect(organization_member.total_members).to eq(7)
    end
  end
end
