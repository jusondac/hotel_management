require "test_helper"

class RoomFacilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @room_facility = room_facilities(:one)
  end

  test "should get index" do
    get room_facilities_url
    assert_response :success
  end

  test "should get new" do
    get new_room_facility_url
    assert_response :success
  end

  test "should create room_facility" do
    assert_difference("RoomFacility.count") do
      post room_facilities_url, params: { room_facility: { facility_id: @room_facility.facility_id, room_id: @room_facility.room_id } }
    end

    assert_redirected_to room_facility_url(RoomFacility.last)
  end

  test "should show room_facility" do
    get room_facility_url(@room_facility)
    assert_response :success
  end

  test "should get edit" do
    get edit_room_facility_url(@room_facility)
    assert_response :success
  end

  test "should update room_facility" do
    patch room_facility_url(@room_facility), params: { room_facility: { facility_id: @room_facility.facility_id, room_id: @room_facility.room_id } }
    assert_redirected_to room_facility_url(@room_facility)
  end

  test "should destroy room_facility" do
    assert_difference("RoomFacility.count", -1) do
      delete room_facility_url(@room_facility)
    end

    assert_redirected_to room_facilities_url
  end
end
