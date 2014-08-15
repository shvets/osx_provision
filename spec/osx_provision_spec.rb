require File.expand_path('spec_helper', File.dirname(__FILE__))

require 'osx_provision'

RSpec.describe OsxProvision do
  subject { OsxProvision.new self.class, ".osx_provision.json" }

  describe "#prepare" do
    it "calls prepare method" do
      expect(subject).to receive(:run)

      subject.prepare
    end
  end

  describe "#homebrew_install" do
    it "calls homebrew_install method" do
      expect(subject).to receive(:run)

      subject.brew
    end
  end
end
