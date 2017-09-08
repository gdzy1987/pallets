require 'active_support'

module Pallets
  module DSL
    module Workflow
      def task(*args, &block)
        options = args.extract_options!
        name, depends_on = if args.any?
          [args.first, options[:depends_on]]
        else
          options.first
        end
        raise ArgumentError, "A task must have a name" unless name
        # Handle nils, symbols or arrays consistently
        dependencies = Array(depends_on).compact
        graph.add(name, dependencies)
        nil
      end
    end
  end
end