module Pallets
  module Util
    extend self

    def camelize(str)
      str.to_s.gsub(/(?:^|_)([a-zA-Z0-9])/) { $1.upcase }
    end

    def constantize(str)
      names = str.split('::')

      # Raise the "usual" NameError
      Object.const_get(str) if names.empty?

      # Handle "::Const" cases
      names.shift if names.first.empty?

      names.inject(Object) do |constant, name|
        if constant.const_defined?(name, false)
          constant.const_get(name, false)
        else
          constant.const_missing(name)
        end
      end
    end
  end
end
