require "application_system_test_case"

class RoomFacilitiesTest < ApplicationSystemTestCase
  setup do
    @room_facility = room_facilities(:one)
  end

  test "visiting the index" do
    visit room_facilities_url
    assert_selector "h1", text: "Room facilities"
  end

  test "should create room facility" do
    visit room_facilities_url
    click_on "New room facility"

    fill_in "Facility", with: @room_facility.facility_id
    fill_in "Room", with: @room_facility.room_id
    click_on "Create Room facility"

    assert_text "Room facility was successfully created"
    click_on "Back"
  end

  test "should update Room facility" do
    visit room_facility_url(@room_facility)
    click_on "Edit this room facility", match: :first

    fill_in "Facility", with: @room_facility.facility_id
    fill_in "Room", with: @room_facility.room_id
    click_on "Update Room facility"

    assert_text "Room facility was successfully updated"
    click_on "Back"
  end

  test "should destroy Room facility" do
    visit room_facility_url(@room_facility)
    accept_confirm { click_on "Destroy this room facility", match: :first }

    assert_text "Room facility was successfully destroyed"
  end
end
