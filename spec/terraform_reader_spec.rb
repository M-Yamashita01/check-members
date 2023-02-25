# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TerraformReader do
  describe 'open_file' do
    it 'get TerraformReader instance' do
      terraform_json_file_path = File.expand_path("#{__dir__}/fixtures/terraform_valid_json.json")
      terraform_reader = described_class.open_file(terraform_json_file_path: terraform_json_file_path)
      expect(terraform_reader.class.name).to eq('TerraformReader')
    end
  end

  describe '#usernames' do
    it 'get members list' do
      terraform_json_file_path = File.expand_path("#{__dir__}/fixtures/terraform_valid_json.json")
      terraform_reader = described_class.open_file(terraform_json_file_path: terraform_json_file_path)
      usernames = terraform_reader.read_members
      expect(usernames).to contain_exactly('Membership1', 'Membership2', 'Membership3')
    end

    context 'when invalid json file' do
      it 'raise StandardError' do
        terraform_json_file_path = File.expand_path("#{__dir__}/fixtures/terraform_invalid_json.json")
        terraform_reader = described_class.open_file(terraform_json_file_path: terraform_json_file_path)
        expect { terraform_reader.read_members }.to raise_error StandardError
      end
    end
  end
end
