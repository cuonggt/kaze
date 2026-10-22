require 'test_helper'

class StackFactoryTest < Kaze::TestCase
  def test_makes_each_supported_stack
    {
      hotwire: Kaze::Commands::App::HotwireStack,
      react: Kaze::Commands::App::InertiaReactStack,
      vue: Kaze::Commands::App::InertiaVueStack
    }.each do |name, klass|
      assert_instance_of klass, Kaze::Commands::App::StackFactory.make(name)
    end
  end

  def test_rejects_an_unknown_stack
    error = assert_raises(Kaze::Commands::InvalidStackError) do
      Kaze::Commands::App::StackFactory.make(:svelte)
    end

    assert_match(/\[hotwire\], \[react\], \[vue\]/, error.message)
  end

  def test_rejects_a_string_rather_than_silently_missing
    assert_raises(Kaze::Commands::InvalidStackError) do
      Kaze::Commands::App::StackFactory.make('react')
    end
  end
end
