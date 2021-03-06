require 'test_helper'

class Api::V1::LinksControllerTest < ActionController::TestCase
  test "controller responds to json" do
    get :index, format: :json
    assert_response :success
  end

  test 'index returns an array of records' do
    get :index, format: :json

    assert_kind_of Array, json_response
  end

  test '#index returns the correct number of links' do
    get :index, format: :json

    assert_equal Link.count, json_response.count
  end

  test '#index contains links with the correct properties' do
    get :index, format: :json

    json_response.each do |link|
      assert link["title"]
      assert link["url"]
      assert link["read"]
    end
  end

  test "#create adds an additional link to to the database" do
    assert_difference 'Link.count', 1 do
      link = { title: "New Link", url: "Something" }

      post :create, link: link, format: :json
    end
  end

  test "#create returns the new link" do
    link = { title: "Google", url: "https://www.google.com" }

    post :create, link: link, format: :json

    assert_equal link[:title], json_response["title"]
    assert_equal link[:url], json_response["url"]
    assert_equal "unread", json_response["read"]
  end

  test "#create rejects links without a title" do
    link = { url: 'Something' }
    number_of_links = Link.all.count

    post :create, link: link, format: :json

    assert_response 422
    assert_includes json_response["errors"]["title"], "can't be blank"
  end

  test "#create rejects links without a url" do
    link = { title: 'New Link' }
    number_of_links = Link.all.count

    post :create, link: link, format: :json

    assert_response 422
    assert_includes json_response["errors"]["url"], "can't be blank"
  end
end
