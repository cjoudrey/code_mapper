module CodeMapper
  module Output
    class Text
      def initialize(io)
        @io = io
        @indent = ''
      end

      def push(tp, normalized_class_name)
        @io.puts "#{@indent}#{normalized_class_name}.#{tp.method_id.to_s}\n"
        @indent << '  '
      end

      def pop(tp, normalized_class_name)
        @indent = @indent[0...-2]
      end

      def done
      end
    end
  end
end
