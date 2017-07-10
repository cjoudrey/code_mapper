module CodeMapper
  module Filter
    class MaxDepth
      def initialize(max_depth)
        @max_depth = max_depth
        @depth = 0
      end

      def keep?(tp, _)
        if call_event?(tp)
          @depth += 1
          return false if @depth > @max_depth
        elsif return_event?(tp)
          old_depth = @depth
          @depth -= 1
          return false if old_depth > @max_depth
        end

        true
      end

      private

      def call_event?(tp)
        tp.event == :call || tp.event == :c_call
      end

      def return_event?(tp)
        tp.event == :return || tp.event == :c_return
      end
    end
  end
end
