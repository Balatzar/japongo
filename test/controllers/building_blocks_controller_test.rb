require "test_helper"

class BuildingBlocksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get building_blocks_index_url
    assert_response :success
  end

  test "should get show" do
    get building_blocks_show_url
    assert_response :success
  end

  test "should get new" do
    get building_blocks_new_url
    assert_response :success
  end

  test "should get create" do
    get building_blocks_create_url
    assert_response :success
  end

  test "should get edit" do
    get building_blocks_edit_url
    assert_response :success
  end

  test "should get update" do
    get building_blocks_update_url
    assert_response :success
  end

  test "should get destroy" do
    get building_blocks_destroy_url
    assert_response :success
  end
end
