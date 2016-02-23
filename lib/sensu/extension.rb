require "eventmachine"
require "sensu/extension/constants"

module Sensu
  module Extension
    class Base
      # @!attribute [rw] logger
      #   @return [Array] logger provided by Sensu.
      attr_accessor :logger

      # @!attribute [rw] settings
      #   @return [Array] settings hash provided by Sensu.
      attr_accessor :settings

      # Initialize the extension, call post_init() when the
      # eventmachine reactor starts up, stop() when it stops.
      def initialize
        EM.next_tick do
          post_init
        end
        EM.add_shutdown_hook do
          stop
        end
      end

      # Override this method to set the extension's name.
      def name
        "base"
      end

      # Override this method to set a name alias for the extension.
      # The extention can be referenced by the name alias. This method
      # is used to aid in the transition to the extension from a Sensu
      # component sharing the same name, e.g. pipe handler.
      def name_alias; end

      # Override this method to set the extension's description.
      def description
        "extension description (change me)"
      end

      # Override this method to change the extension's definition, a
      # hash. You probably don't need to touch this. The hash must
      # contain :type ("extension") and :name.
      def definition
        {
          :type => "extension",
          :name => name
        }
      end

      # Override this method to do something immediately after the
      # eventmachine reactor is started. This method is great for
      # setting up connections etc.
      def post_init
        true
      end

      # Override this method to do something when the extension is
      # run, you must yield or call the callback with two parameters,
      # an output string and exit code.
      #
      # @param data [Object, nil] provided by Sensu.
      # @param options [Hash] provided by Sensu, may contain
      #   connection objects, eg. redis.
      # @yield [output, status] callback/block provided by Sensu,
      #   expecting to be called with two parameters, an output string
      #   and exit status code.
      # @yieldparam output [String]
      # @yieldparam status [Integer]
      def run(data=nil, options={})
        yield("noop", 0)
      end

      # Override this method to do something when the eventmachine
      # reactor stops, such as connection or file cleanup.
      def stop
        true
      end

      # Retrieve the definition object corresponding to a key, acting
      # like a Hash object. Do not override this method!
      #
      # @param key [String, Symbol]
      # @return [Object] value for key.
      def [](key)
        definition[key.to_sym]
      end

      # Check to see if the definition has a key. Do not override this
      # method!
      #
      # @param key [String, Symbol]
      # @return [TrueClass, FalseClass]
      def has_key?(key)
        definition.has_key?(key.to_sym)
      end

      # Run the extension with a few safeties. This method wraps
      # run() with a begin;rescue, and duplicates data before passing
      # it to ensure the extension doesn't mutate the original. Do
      # not override this method!
      #
      # @param data [Object, nil) to dup() and pass to run(), if run()
      #   has an absolue arity of 1 or more.
      # @param options [Hash] to pass to run(), if run() has an
      #   absolute arity of 2.
      # @yield [output, status] callback/block provided by Sensu,
      #   expecting to be called with two parameters, an output string
      #   and exit status code.
      # @yieldparam output [String]
      # @yieldparam status [Integer]
      def safe_run(data=nil, options={})
        begin
          @run_arity ||= method(:run).arity.abs
          arguments = []
          arguments << (data ? data.dup : data) if @run_arity >= 1
          arguments << options if @run_arity == 2
          run(*arguments) do |output, status|
            yield(output, status)
          end
        rescue => error
          klass = error.class.name
          backtrace = error.backtrace.map { |line| "\s\s#{line}" }.join("\n")
          yield("#{klass}: #{error}\n#{backtrace}", 2)
        end
      end

      # Determine classes that have inherited this class, used by the
      # extension loader. Do not override this method!
      #
      # @return [Array<object>]
      def self.descendants
        ObjectSpace.each_object(Class).select do |klass|
          klass < self
        end
      end
    end

    # Create an extension class for each category from Base.
    CATEGORIES.each do |category|
      extension_type = category.to_s.chop
      Sensu::Extension.const_set(extension_type.capitalize, Class.new(Base))
    end
  end
end
