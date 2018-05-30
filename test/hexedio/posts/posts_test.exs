defmodule Hexedio.PostsTest do
  use Hexedio.DataCase

  alias Hexedio.Posts

  describe "posts" do
    alias Hexedio.Posts.Post

    @valid_attrs %{content: "some content", date_published: ~D[2010-04-17], excerpt: "some excerpt", published: true, slug: "some slug", title: "some title"}
    @update_attrs %{content: "some updated content", date_published: ~D[2011-05-18], excerpt: "some updated excerpt", published: false, slug: "some updated slug", title: "some updated title"}
    @invalid_attrs %{content: nil, date_published: nil, excerpt: nil, published: nil, slug: nil, title: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Posts.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Posts.create_post(@valid_attrs)
      assert post.content == "some content"
      assert post.date_published == ~D[2010-04-17]
      assert post.excerpt == "some excerpt"
      assert post.published == true
      assert post.slug == "some slug"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, post} = Posts.update_post(post, @update_attrs)
      assert %Post{} = post
      assert post.content == "some updated content"
      assert post.date_published == ~D[2011-05-18]
      assert post.excerpt == "some updated excerpt"
      assert post.published == false
      assert post.slug == "some updated slug"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
