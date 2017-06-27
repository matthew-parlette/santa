require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  test "user is assigned to another user" do
    a = Assignment.new()
    a.user = User.first
    a.assigned_to = User.last
    a.year = 2017
    assert a.save!
  end

  test "user is assigned to another user over two years" do
    a = Assignment.new()
    a.user = User.first
    a.assigned_to = User.last
    a.year = 2017
    assert a.save!

    b = Assignment.new()
    b.user = User.first
    b.assigned_to = User.last
    b.year = 2016
    assert b.save!
  end
end
