# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ConfigValidator do
  describe '#validate?' do
    subject { config_validator.validate }

    let(:access_token) { 'Sample Access Token' }
    let(:terraform_json_file_path) { "#{__dir__}/fixtures/terraform_valid_json.json" }
    let(:organization_name) { 'organization-test' }
    let(:verify_account) { nil }

    let(:config_validator) do
      ConfigValidator.new(
        access_token: access_token,
        terraform_json_file_path: terraform_json_file_path,
        organization_name: organization_name,
        verify_account: nil
      )
    end

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

    context 'Terraform json file path is empty' do
      let(:terraform_json_file_path) { '' }

      it { expect(config_validator.validate?).to be_falsey }
    end

    # context 'Terraform directory path does not exist.' do
    #   let(:terraform_json_file_path) { "#{__dir__}/spec_sample" }

    #   it { expect(config_validator.validate?).to be_falsey }
    # end

    context 'Organization Name is empty' do
      let(:organization_name) { '' }

      it { expect(config_validator.validate?).to be_falsey }
    end

    context 'Organization Name is nil' do
      let(:organization_name) { nil }

      it { expect(config_validator.validate?).to be_falsey }
    end

    context 'Verify account is true' do
      let(:verify_account) { 'true' }

      it { expect(config_validator.validate?) }
    end

    context 'Verify account is false' do
      let(:verify_account) { 'false' }

      it { expect(config_validator.validate?) }
    end

    context 'Verify account is sample string' do
      let(:verify_account) { 'sample' }

      it { expect(config_validator.validate?) }
    end
  end
end
