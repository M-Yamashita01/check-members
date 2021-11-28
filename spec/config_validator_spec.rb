# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ConfigValidator do
  describe '#validate?' do
    let(:access_token) { 'Sample Access Token' }
    let(:membership_file_path) { "#{__dir__}/fixtures/membership.tf" }
    let(:repository_collaborator_file_path) { "#{__dir__}/fixtures/repository_collaborator.tf" }
    let(:organization_name) { 'organization-test' }

    let(:config_validator) do
      ConfigValidator.new(
        access_token: access_token,
        membership_file_path: membership_file_path,
        repository_collaborator_file_path: repository_collaborator_file_path,
        organization_name: organization_name
      )
    end

    subject { config_validator.validate }

    context 'All environment variables are valid.' do
      it { expect(config_validator.validate?).to be_truthy }
    end

    context 'Access token is empty' do
      let(:access_token) { '' }

      it { expect(config_validator.validate?).to be_falsey }
    end

    context 'Access token is nil' do
      let(:access_token) { nil }

      it { expect(config_validator.validate?).to be_falsey }
    end

    context 'Membership file path is empty' do
      let(:membership_file_path) { '' }

      it { expect(config_validator.validate?).to be_falsey }
    end

    context 'Repository Collaborator file path is empty' do
      let(:repository_collaborator_file_path) { '' }

      it { expect(config_validator.validate?).to be_falsey }
    end

    context 'Organization Name is empty' do
      let(:organization_name) { '' }

      it { expect(config_validator.validate?).to be_falsey }
    end

    context 'Organization Name is nil' do
      let(:organization_name) { nil }

      it { expect(config_validator.validate?).to be_falsey }
    end
  end
end
