require 'spec_helper'

RSpec.describe PageConfig::Api::V1 do

  describe 'before filters' do

    context "when client doesn't specify correct Accept header" do
      it "returns 406 with appropriate message" do
        get "/pages", {}, {"HTTP_ACCEPT"=>"text/plain"}

        expect(last_response.body).to eq({msg: "Invalid Accept header."}.to_json)
        expect(last_response.status).to eq 406
      end
    end

    context "with correct Accept header" do
      it "allows to call underlying actions" do
        get "/pages", {}, {"HTTP_ACCEPT"=>"application/json"}

        expect(last_response.status).to eq 200
      end
    end

    it "sets correct content_type response header" do
      get "/pages"

      expect(last_response.header["Content-Type"]).to eq "application/json"
      expect(last_response.status).to eq 200
    end

  end

  describe "GET /pages" do

    context "when there is no configuration stored" do
      it "returns an empty list all configs" do
        get "/pages"

        expect(last_response.body).to eq({page: []}.to_json)
        expect(last_response.status).to eq 200
      end
    end

    context "when there is at least 1 page configuration" do
      before do
        Page.create(name: "foo1", config: {key1: "val1"})
        Page.create(name: "foo2", config: {key2: "val2"})
      end

      let(:expected_output) do
        {
          page: [
            {id: "foo2", config: {key2: "val2"}},
            {id: "foo1", config: {key1: "val1"}}
          ]
        }.to_json
      end

      it "returns all stored page configs" do
        get "/pages"

        expect(last_response.body).to eq expected_output
        expect(last_response.status).to eq 200
      end
    end
  end

end
