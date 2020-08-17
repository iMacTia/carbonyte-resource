# frozen_string_literal: true

RSpec.describe Carbonyte::Resource do
  it 'has a version number' do
    expect(Carbonyte::Resource::VERSION).not_to be nil
  end
end
