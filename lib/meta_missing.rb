require "active_support"
require "active_support/core_ext/class/attribute"
require "patched"

module MetaMissing
  include Patched

  using patched(Proc) {
    def bind(object)
      block, time = self, Time.now
      object.class_eval do
        method_name = "__bind_#{time.to_i}_#{time.usec}"
        define_method(method_name, &block)
        instance_method(method_name).tap do
          remove_method(method_name)
        end
      end.bind(object)
    end
  }
  
  def self.prepended(base)
    base.class_eval do
      extend ClassMethods

      class_attribute :method_handlers
      self.method_handlers = []
    end
  end
  
  def self.bind(proc, context)
    proc.bind(context)
  end
  
  def method_missing(name, *args, &block)
    if handler = method_handlers.find { |handler| handler[:regexp] =~ name.to_s }
      if block_given?
        class_eval do
          alias_method :orig_block_given?, :block_given?
          def block_given?; true; end
        end
        
        MetaMissing.bind(handler[:block], self)[handler[:regexp], name, *args, &block].tap do
          class_eval do
            alias_method :block_given?, :orig_block_given?
            remove_method :orig_block_given?
          end
        end
      else
        instance_exec(handler[:regexp], name, *args, &handler[:block])
      end
    else super end
  end
  
  module ClassMethods
    def handle_methods_like(regexp, &block)
      method_handlers << { regexp: regexp, block: block }
    end
  end
end
