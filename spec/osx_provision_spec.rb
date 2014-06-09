require File.expand_path('spec_helper', File.dirname(__FILE__))

require 'osx_provision/osx_provision'

describe OsxProvision do
  subject { OsxPrivision.new ".osx_provision.json", "osx_provision_scripts.sh"}

  describe "#init_launch_agent" do
    it "calls prepare method" do
      subject.jenkins_install
    end
  end

  describe "#init_launch_agent" do
    it "calls init_launch_agent method" do
      subject.init_launch_agent
    end
  end

  describe "#homebrew_install" do
    it "calls homebrew_install method" do
      subject.homebrew_install
    end
  end
end
