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

Puma::Plugin.create do
  def start(launcher)
    launcher.define_singleton_method(:phased_restart) do
      init_options = { config_files: @options.all_of(:config_files) }
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