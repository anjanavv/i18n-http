RSpec.describe I18n::Http::Request do
  describe 'call' do
    before do
      I18n::Http.configure do |config|
        config.enabled = true
        config.endpoint = "https://api.host.com/path/to/api/{locale}"
      end
    end

    context "when api is success" do
      it 'should return the response' do
        response = {
          en: {
            hello: "Hello world"
          }
        }
        stub_request(:get, "https://api.host.com/path/to/api/en").
         with(
           headers: {
            'Accept'=>'application/json',
            'Content-Type'=>'application/json',
           }).
         to_return(status: 200, body: response.to_json, headers: {})
        api_response = described_class.new(:en).call
        expect(api_response).to eq(response.to_json)
      end
    end

    context "when api api is not success" do
      it 'should not blank' do
        stub_request(:get, "https://api.host.com/path/to/api/en").
         with(
           headers: {
            'Accept'=>'application/json',
            'Content-Type'=>'application/json',
           }).
         to_return(status: 400, body: "", headers: {})
        api_response = described_class.new(:en).call
        expect(api_response).to eq(nil)
      end
    end

    context "when api raised error" do
      it 'should not blank' do
        stub_request(:get, "https://api.host.com/path/to/api/en").
         with(
           headers: {
            'Accept'=>'application/json',
            'Content-Type'=>'application/json',
           }).and_raise("error")
        api_response = described_class.new(:en).call
        expect(api_response).to eq(nil)
      end
    end
  end
end
