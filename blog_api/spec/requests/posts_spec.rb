require "rails_helper"

RSpec.describe "Posts", type: :request do
  describe "POST /posts" do
    let(:user) { create(:user) }
    let(:valid_params) do
      {
        post: {
          title: "Hello",
          body: "World",
          user_id: user.id
        }
      }
    end

    context "正常系" do
      it "201 Created と JSON body を返す" do
        expect {
          post "/posts", params: valid_params, as: :json
        }.to change(Post, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["title"]).to eq("Hello")
        expect(json["body"]).to eq("World")
        expect(json["user_id"]).to eq(user.id)
      end

      it "Location ヘッダーで作成されたリソース URL を返す" do
        post "/posts", params: valid_params, as: :json

        expect(response.headers["Location"]).to match(%r{/posts/\d+\z})
      end
    end

    context "異常系: バリデーション違反" do
      it "title 欠落で 422 とエラーメッセージを返す" do
        invalid = valid_params.deep_dup
        invalid[:post][:title] = ""

        expect {
          post "/posts", params: invalid, as: :json
        }.not_to change(Post, :count)

        expect(response).to have_http_status(:unprocessable_content)
        json = JSON.parse(response.body)
        expect(json["title"]).to include("can't be blank")
      end

      it "user_id 欠落で 422 を返す（belongs_to の暗黙 presence）" do
        invalid = valid_params.deep_dup
        invalid[:post].delete(:user_id)

        post "/posts", params: invalid, as: :json

        expect(response).to have_http_status(:unprocessable_content)
        json = JSON.parse(response.body)
        expect(json["user"]).to include("must exist")
      end
    end

    context "境界: Strong Params" do
      it "許可外キー(admin)は silently filter されて保存されない" do
        payload = valid_params.deep_dup
        payload[:post][:admin] = true

        post "/posts", params: payload, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json).not_to have_key("admin")
      end

      it "wrap_parameters により flat payload も post: にラップされて 201" do
        post "/posts",
             params: { title: "Flat", body: "Body", user_id: user.id },
             as: :json

        expect(response).to have_http_status(:created)
      end
    end
  end
end
