class ShuntingYard
  OPERATORS = {
    '*' => 20,
    '+' => 10,
    '-' => 10
  }.freeze

  attr_reader :operator_stack

  def initialize
    @operator_stack = []
  end

  def shunt(input)
    output = []

    input.each do |token|
      if operator?(token)
        while operator_stack.any? && precedence(token) <= precedence(top_of_operator_stack)
          output << operator_stack.pop
        end
          
        operator_stack << token
      else
        output << token
      end
    end

    output << operator_stack.pop until operator_stack.empty?

    output
  end

  private

  def top_of_operator_stack
    operator_stack.last
  end

  def operator?(token)
    OPERATORS.key?(token)
  end

  def precedence(token)
    OPERATORS.fetch(token)
  end
end

RSpec.describe ShuntingYard do
  describe '.shunt' do
    specify do
      expect(subject.shunt(['1'])).to eq(['1'])
    end

    specify do
      expect(subject.shunt(%w(1 + 2))).to eq(%w(1 2 +))
    end

    specify do
      expect(subject.shunt(%w(1 + 2 - 3))).to eq(%w(1 2 + 3 -))
    end

    specify do
      expect(subject.shunt(%w(1 + 2 * 3))).to eq(%w(1 2 3 * +))
    end

    specify do
      expect(subject.shunt(%w(1 - 2 - 3))).to eq(%w(1 2 - 3 -))
    end
  end
end
