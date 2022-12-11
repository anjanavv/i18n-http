RSpec.describe I18n::Http do
  it "has a version number" do
    expect(I18n::Http::VERSION).not_to be nil
  end

  describe 'configure' do
    context "when configured" do
      it 'should set the values' do
        I18n::Http.configure do |config|
          config.enabled = true
          config.endpoint = "https://api.host.com/path"
        end

        configuration = I18n::Http.config
        expect(configuration.enabled).to eq(true)
        expect(configuration.endpoint).to eq("https://api.host.com/path")
      end
    end
  end
end
