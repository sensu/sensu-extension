require File.join(File.dirname(__FILE__), "helpers")
require "sensu/extension"
require "logger"

describe "Sensu::Extension::Base" do
  include Helpers

  before do
    @extension = Sensu::Extension::Base.new
  end

  it "can provide the extension API" do
    expect(@extension).to respond_to(:name, :description, :definition, :safe_run, :has_key?, :[])
  end

  it "can provide default method return values" do
    expect(@extension.post_init).to be(true)
    expect(@extension.stop).to be(true)
    expect(@extension.name).to eq("base")
    expect(@extension.description).to eq("extension description (change me)")
    expect(@extension.definition).to eq({:type => "extension", :name => "base"})
  end

  it "can have a logger" do
    @extension.logger = Logger.new("/dev/null")
    @extension.logger.formatter = Proc.new do |severity, datetime, progname, message|
      expect(severity).to eq("INFO")
      expect(message).to eq("test")
    end
    @extension.logger.info("test")
  end

  it "can have settings" do
    settings = {:foo => 1}
    @extension.settings = settings
    expect(@extension.settings).to eq(settings)
  end

  it "can run without data" do
    async_wrapper do
      callback = Proc.new do |output, status|
        expect(output).to eq("noop")
        expect(status).to eq(0)
        async_done
      end
      @extension.run(&callback)
    end
  end

  it "can run with event data" do
    async_wrapper do
      callback = Proc.new do |output, status|
        expect(output).to eq("noop")
        expect(status).to eq(0)
        async_done
      end
      event = {:foo => 1}
      @extension.run(event, &callback)
    end
  end

  it "can pass duplicated event data to run" do
    async_wrapper do
      event = {:foo => 1}
      @extension.safe_run(event) do |output, status|
        expect(output).to eq("noop")
        expect(status).to eq(0)
        async_done
      end
    end
  end

  it "can catch some run errors" do
    async_wrapper do
      @extension.safe_run do |output, status|
        raise "boom" if status == 0
        expect(output).to eq("boom")
        expect(status).to eq(2)
        async_done
      end
    end
  end

  it "can provide hash like access to definition()" do
    expect(@extension.has_key?(:type)).to be(true)
    expect(@extension.has_key?(:name)).to be(true)
    expect(@extension[:type]).to eq("extension")
    expect(@extension[:name]).to eq("base")
  end

  it "can provide a list of decendant classes" do
    expected = [
      Sensu::Extension::Bridge,
      Sensu::Extension::Check,
      Sensu::Extension::Mutator,
      Sensu::Extension::Handler
    ]
    expect(Sensu::Extension::Base.descendants).to include(*expected)
  end
end
