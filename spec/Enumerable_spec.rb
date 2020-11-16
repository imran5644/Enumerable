# spec/Enumerable_spec.rb
require_relative '../main'
describe Enumerable do
  let(:arr) { [1, 2, 3] }
  let(:hash) { { 'x' => 'a', 'y' => 'b' } }
  let(:range) { (1...5) }
  let(:astring) { %w[cat dog wombat] }
  describe '#my_each' do
    context 'it runs to the end of my_each if arguments are passed returns enum otherwise' do
      it { expect(arr.my_each).to be_instance_of(Enumerator) }
      it { expect(hash.my_each).to be_instance_of(Enumerator) }
      it { expect(arr.my_each { |x| puts x * 2 }).not_to eql([2, 4, 6]) }
      it { expect(arr.my_each { |x| puts x * 2 }).to be_instance_of(Array) }
      it { expect(range.my_each { |x| puts x * 2 }).not_to be_instance_of(Array) }
      it { expect(hash.my_each { |x| puts x * 2 }).not_to be_instance_of(Array) }
      it { expect { arr.my_each(1) { |x| puts x } }.to raise_error(ArgumentError) }
      it { expect { arr.my } }
      it { expect { |x| arr.my_each(&x) }.to yield_control }
      specify { expect { print(arr.my_each) }.to output.to_stdout }

      describe '#my_each_with_index' do
        context 'it goes through the array and processes the elements and indices' do
          it { expect(astring.my_each_with_index).to be_instance_of(Enumerator) }
          it { expect(astring.my_each_with_index { |x, y| puts x, y }).not_to eql({ 'cat' => 0, 'dog' => 1, 'wombat' => 2 }) }
          it { expect(range.my_each_with_index { |_e, i| e = i * 2 }).to be_eql(range) }
          it { expect { [astring, 'another'].my_each_with_index(3) { |e, i| puts e, i } }.to raise_error(ArgumentError) }
        end
      end
      describe '#my_select' do
        context 'select elements with given condition' do
          it { expect(arr.my_select).to be_instance_of(Enumerator) }
          it { expect(arr.my_select(&:odd?)).to be_eql([1, 3]) }
          it { expect(arr.my_select(&:even?)).to contain_exactly(2) }

          it { expect(hash.my_select { |e| e == 'x' }).not_to be_instance_of(Hash) }
          it { expect { arr.my_select(4) }.to raise_error(ArgumentError) }
          it { expect((1..10).my_select(&:even?)).to contain_exactly(2, 4, 6, 8, 10) }
          it { expect(%i[foo bar].my_select { |x| x == :foo }).to contain_exactly(:foo) }
        end
      end
    end
  end
end
