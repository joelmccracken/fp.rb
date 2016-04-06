module FP
  class Fn
    def self.method_added(method_name, &block)
      is_attr_reader = (@arguments || []).include?(method_name)
      is_public_method = public_instance_methods.include?(method_name)

      if !is_attr_reader && is_public_method
        eval <<-EOS
          def self.#{method_name}(*args, &block)
            new(*args, &block).#{method_name}
          end
        EOS
      end
    end

    def self.arguments(*args)
      maybe_spec = args.last

      if maybe_spec.is_a?(Hash)
        @arguments = args[0..-2]
        @spec = args.last
      else
        @arguments = args
        @spec = nil
      end

      by_name = @spec && @spec[:by] == :name
      by_position = @spec && [:pos, :position].include?(@spec[:by])
      no_spec = !@spec

      attr_readers = @arguments.map { |arg| ":#{arg}"}.join ", "

      eval "attr_reader #{attr_readers}"

      attr_assignments = @arguments.map { |arg|
        "@#{arg} = #{arg}"
      }.join("\n")

      if by_position || no_spec
        arguments_string = @arguments.join(", ")

        eval <<-EOS
          def initialize(#{arguments_string})
            #{attr_assignments}
          end
        EOS
      elsif by_name
        arguments_string = @arguments.map{ |arg| "#{arg}:"}.join(", ")
        eval <<-EOS
          def initialize(#{arguments_string})
            #{attr_assignments}
          end
        EOS
      else
        raise "Unknown value (#{@spec && @spec[:by]}) for arguments spec :by parameter; valid options are :name and :position"
      end
    end
  end
end
