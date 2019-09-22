require "test_helper"

class VkdonateTest < Minitest::Test


  def test_version_number
    refute_nil Vkdonate::VERSION
  end

  def test_donates
    puts "Please enter API key:"
    api_key = STDIN.gets.chomp
    client = Vkdonate::Client.new api_key

    donates = client.donates
    assert_instance_of Array, donates, "donates method must return Array"
    assert_instance_of Vkdonate::Donate, donates.first, "donates method must return Donate objects" unless donates.empty?
  end
  
end
