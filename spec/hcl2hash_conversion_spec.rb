# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hcl2hashConversion do
  describe '#convert_to_hash' do
    context 'when terraform file is converted into json correctly' do
      it 'count github_membership from json format of terraform file' do
        actual_json = described_class.convert_to_hash(terraform_file_path: "#{__dir__}/fixtures/membership.tf")
        github_membership = actual_json['resource']['github_membership']
        expect(github_membership.count).to eq(8)
      end
    end

    context 'when Open3.capture3 returns error outputs' do
      before do
        allow(Open3).to receive(:capture3).and_return(['', 'error', ''])
      end

      it 'raise standard exception' do
        expect { described_class.convert_to_hash(terraform_file_path: "#{__dir__}/fixtures/membership.tf") }
          .to raise_error(RuntimeError, 'error')
      end
    end
  end
end
