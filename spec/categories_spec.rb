require File.join(File.dirname(__FILE__), "helpers")
require "sensu/extension"

describe "Sensu::Extension::Generic" do
  include Helpers

  it "inherits Base" do
    Sensu::Extension::Generic.superclass.should eq(Sensu::Extension::Base)
    extension = Sensu::Extension::Generic.new
    extension.should respond_to(:name, :description, :definition, :safe_run, :stop, :has_key?, :[])
  end
end

describe "Sensu::Extension::Bridge" do
  include Helpers

  it "inherits Base" do
    Sensu::Extension::Bridge.superclass.should eq(Sensu::Extension::Base)
    extension = Sensu::Extension::Bridge.new
    extension.should respond_to(:name, :description, :definition, :safe_run, :stop, :has_key?, :[])
  end
end

describe "Sensu::Extension::Check" do
  include Helpers

  it "inherits Base" do
    Sensu::Extension::Check.superclass.should eq(Sensu::Extension::Base)
    extension = Sensu::Extension::Check.new
    extension.should respond_to(:name, :description, :definition, :safe_run, :stop, :has_key?, :[])
  end
end

describe "Sensu::Extension::Mutator" do
  include Helpers

  it "inherits Base" do
    Sensu::Extension::Mutator.superclass.should eq(Sensu::Extension::Base)
    extension = Sensu::Extension::Mutator.new
    extension.should respond_to(:name, :description, :definition, :safe_run, :stop, :has_key?, :[])
  end
end

describe "Sensu::Extension::Handler" do
  include Helpers

  it "inherits Base" do
    Sensu::Extension::Handler.superclass.should eq(Sensu::Extension::Base)
    extension = Sensu::Extension::Handler.new
    extension.should respond_to(:name, :description, :definition, :safe_run, :stop, :has_key?, :[])
  end
end
