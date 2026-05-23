require "rails_helper"

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:post_record) { create(:post, user: user) }

  describe "GET /posts/:post_id/comments" do
    let!(:comment1) { create(:comment, post: post_record, user: user) }
    let!(:comment2) { create(:comment, post: post_record, user: user) }

    it "post に紐づく comments を返す" do
      get "/posts/#{post_record.id}/comments"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(2)
    end

    it "存在しない post_id は 404" do
      get "/posts/9999/comments"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /posts/:post_id/comments" do
    let(:valid_params) { { comment: { body: "Nice post!", user_id: user.id } } }

    context "正常系" do
      it "201 と JSON body を返し、件数が 1 増える" do
        expect {
          post "/posts/#{post_record.id}/comments", params: valid_params, as: :json
        }.to change(Comment, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["body"]).to eq("Nice post!")
        expect(json["post_id"]).to eq(post_record.id)
      end
    end

    context "異常系" do
      it "body 欠落で 422" do
        invalid = valid_params.deep_dup
        invalid[:comment][:body] = ""

        post "/posts/#{post_record.id}/comments", params: invalid, as: :json

        expect(response).to have_http_status(:unprocessable_content)
        json = JSON.parse(response.body)
        expect(json["body"]).to include("can't be blank")
      end
    end
  end
end
