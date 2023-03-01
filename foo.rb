class Foo
  attr_accessor :bar
  def initialize(bar)
    @bar = bar
  end
end

class Bar
  attr_accessor :msg
  def initialize
    @msg = "bar"
  end
end
@bar = Bar.new
foo = Foo.new(@bar)
puts foo.bar.msg
