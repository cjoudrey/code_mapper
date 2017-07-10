module CodeMapper
  class Tracer
    def initialize(filters: [], output:)
      @filters = filters
      @output = output
    end

    def enable
      tracer.enable
    end

    def disable
      tracer.disable
      @output.done
    end

    private

    def tracer
      indent = ''

      @tracer ||= TracePoint.new(:call, :c_call, :return, :c_return) do |tp|
        normalized_class_name = tp.defined_class.to_s
          .sub(/\#<Class\:(.*)\>/, '\1')
          .sub(/\#<(.*)\:0x[0-f]+\>/, '\1')

        next if @filters.any?{ |filter| !filter.keep?(tp, normalized_class_name) }

        if tp.event == :call || tp.event == :c_call
          @output.push(tp, normalized_class_name)
        elsif tp.event == :return || tp.event == :c_return
          @output.pop(tp, normalized_class_name)
        end
      end
    end
  end
end
