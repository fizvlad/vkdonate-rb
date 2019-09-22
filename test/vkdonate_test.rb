require "test_helper"

class VkdonateTest < Minitest::Test

  def test_version_number
    refute_nil Vkdonate::VERSION
  end
  
end
