module CodeMapper
  module Filter
    class StartAt
      def initialize(start_matcher)
        @start_matcher = start_matcher
        @started = false
        @stack = []
      end

      def keep?(tp, normalized_class_name)
        class_and_method = "#{normalized_class_name}.#{tp.method_id}"

        if !@started && call_event?(tp) && matches?(class_and_method)
          @started = true
        end

        if @started && call_event?(tp)
          @stack << class_and_method
          return true
        end

        if @started && return_event?(tp)
          @stack.pop

          if @stack.empty?
            @started = false
          end
        end

        @started
      end

      private

      def call_event?(tp)
        tp.event == :call || tp.event == :c_call
      end

      def return_event?(tp)
        tp.event == :return || tp.event == :c_return
      end

      def matches?(class_and_method)
        case @start_matcher
        when Regexp
          (@start_matcher =~ class_and_method) != nil
        when String
          @start_matcher == class_and_method
        end
      end
    end
  end
end
