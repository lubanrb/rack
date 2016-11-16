# Backport :define_singleton_method
unless Kernel.method_defined? :define_singleton_method
  module Kernel
    def define_singleton_method(*args, &block)
      class << self
        self
      end.send(:define_method, *args, &block)
    end
  end
end

if RUBY_VERSION =~ /^1\.8/
  # Monkey patched to ensure backward compatibility with Ruby 1.8
  class Puma::Plugin
    # Matches
    #  "C:/Ruby22/lib/ruby/gems/2.2.0/gems/puma-3.0.1/lib/puma/plugin/tmp_restart.rb:3:in `<top (required)>'"
    #  AS
    #  C:/Ruby22/lib/ruby/gems/2.2.0/gems/puma-3.0.1/lib/puma/plugin/tmp_restart.rb
    CALLER_FILE = /
      \A       # start of string
      .+       # file path (one or more characters)
      (?=      # stop previous match when
        :\d+     # a colon is followed by one or more digits
      )
    /x
  end
end

Puma::Plugin.create do
  def start(launcher)
    launcher.define_singleton_method(:phased_restart) do
      init_options = { :config_files => @options.all_of(:config_files) }
      @options.instance_variable_set(:@cur, init_options)
      @options.instance_variable_set(:@set, [init_options])
      @config.load
      if dir = @options[:directory]
        @restart_dir = dir
      end
      set_process_title
      super()
    end
  end
end