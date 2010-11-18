module Mongomatic
  module Observable
    def self.included(base)
      base.send(:extend, ClassMethods)
      add_existing_observer(base)
    end
    
    def self.add_existing_observer(base)
      return unless (observers = Observer.subclasses).size > 0
      the_observer = Observer.subclasses.select { |o| o.to_s.gsub('Observer', '') == base.to_s }.first
      base.add_observer(the_observer) if the_observer
    end
    
    module ClassMethods
      def observers
        @observers ||= []
      end
      
      def add_observer(klass)
        @observers ||= []
        @observers << klass
      end
      
      def has_observer?(klass)
        @observers.include?(klass)
      end
    end
  end
end