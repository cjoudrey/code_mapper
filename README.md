# CodeMapper

CodeMapper is a tool to generate call graphs from your Ruby code.

I built this tool in order to familiarize myself with new Ruby codebases. You can read all about it [here](https://medium.com/@cjoudrey/familiarizing-myself-with-a-new-codebase-using-rubys-tracepoint-and-graphviz-aebd5d6ac2cd).

![](https://github.com/cjoudrey/code_mapper/raw/master/sample-graph.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'code_mapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install code_mapper

## Usage

Generating a call graph and outputting as text to STDOUT:

```ruby
CodeMapper.trace do
  # Code to trace
end
```

You can limit what classes and methods are outputted using `filter`:

```ruby
CodeMapper.trace(filter: /^Dog\./) do
  Dog.new # will get outputted
  Cat.new # won't get outputted
end
```

You can also limit the tracing to a specific lexical scope using `start_at`:

```ruby
CodeMapper.trace(filter: /^Dog\./, start_at: 'Dog.bark') do
  dog = Dog.new # won't get outputted
  dog.bark # will get outputted and all Dog.* calls made within Dog.bark
  Dog.new # will get outputted
  Cat.new # won't get outputted
end
```

You can limit the depth of the call graph using `max_depth`:

```ruby
CodeMapper.trace(max_depth: 3) do
  # Code to trace - only first 3 levels will be outputted
end
```

By default, the call graph will be outputted as text to `STDOUT`.

However you can output the call graph to any `IO`:

```ruby
CodeMapper.trace(output: CodeMapper::Output::Text.new($STDERR)) do
  # Code to trace
end
```

CodeMapper is also capable of outputting `dot` graphs which can be converted to an image using [`graphviz`](http://graphviz.org):

```ruby
file = File.open('graph.dot', 'w')
CodeMapper.trace(output: CodeMapper::Output::Dot.new(file)) do
  # Code to trace
end
file.close
```

```
$ dot -Tpng graph.dot > graph.png
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cjoudrey/code_mapper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

