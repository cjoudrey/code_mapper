require 'graphviz'

module CodeMapper
  module Output
    class Dot
      def initialize(io)
        @io = io
        @stack = []

        @graph = Graphviz::Graph.new('CodeMapper')
        @graph.attributes[:rankdir] = 'LR'
      end

      def push(tp, normalized_class_name)
        node = @graph.add_node("#{normalized_class_name}.#{tp.method_id.to_s}")
        node.attributes[:shape] = 'rectangle'

        if @stack != []
          @stack.last.connect(node)
        end

        @stack << node
      end

      def pop(tp, normalized_class_name)
        @stack.pop
      end

      def done
        @io.puts @graph.to_dot
      end
    end
  end
end
