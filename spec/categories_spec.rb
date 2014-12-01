require File.join(File.dirname(__FILE__), "helpers")
require "sensu/extension"

describe "Sensu::Extension::Bridge" do
  include Helpers

  it "inherits Base" do
    expect(Sensu::Extension::Bridge.superclass).to eq(Sensu::Extension::Base)
    extension = Sensu::Extension::Bridge.new
    expect(extension).to respond_to(:name, :description, :definition, :safe_run, :stop, :has_key?, :[])
  end
end

describe "Sensu::Extension::Check" do
  include Helpers

  it "inherits Base" do
    expect(Sensu::Extension::Check.superclass).to eq(Sensu::Extension::Base)
    extension = Sensu::Extension::Check.new
    expect(extension).to respond_to(:name, :description, :definition, :safe_run, :stop, :has_key?, :[])
  end
end

describe "Sensu::Extension::Filter" do
  include Helpers

  it "inherits Base" do
    expect(Sensu::Extension::Filter.superclass).to eq(Sensu::Extension::Base)
    extension = Sensu::Extension::Filter.new
    expect(extension).to respond_to(:name, :description, :definition, :safe_run, :stop, :has_key?, :[])
  end
end

describe "Sensu::Extension::Mutator" do
  include Helpers

  it "inherits Base" do
    expect(Sensu::Extension::Mutator.superclass).to eq(Sensu::Extension::Base)
    extension = Sensu::Extension::Mutator.new
    expect(extension).to respond_to(:name, :description, :definition, :safe_run, :stop, :has_key?, :[])
  end
end

describe "Sensu::Extension::Handler" do
  include Helpers

  it "inherits Base" do
    expect(Sensu::Extension::Handler.superclass).to eq(Sensu::Extension::Base)
    extension = Sensu::Extension::Handler.new
    expect(extension).to respond_to(:name, :description, :definition, :safe_run, :stop, :has_key?, :[])
  end
end
