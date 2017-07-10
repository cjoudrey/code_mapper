module CodeMapper
  module Filter
    class Callee
      def initialize(callee_matcher)
        @callee_matcher = callee_matcher
      end

      def keep?(tp, normalized_class_name)
        class_and_method = "#{normalized_class_name}.#{tp.method_id}"

        (@callee_matcher =~ class_and_method) != nil
      end
    end
  end
end
