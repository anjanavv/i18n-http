RSpec.describe I18n::Http::Request do
  let(:available_locales) { [:en, :de] }

  let(:key) { 'key' }
  let(:translation) { 'value' }
  let(:en_response) { 
    {
      en: {
        hello: "Hello",
        welcome: "Welcome"
      }
    }
  }
  let(:de_response) { 
    {
      de: {
        hello: "Hallo"
      }
    }
  }

  before do
    allow(I18n.config).to receive(:available_locales).and_return(available_locales)
    I18n.default_locale = :en
  end

  describe '#translate' do
    context "when locale and default_locale is same" do
      context 'when config is disabled' do
        before do
          I18n::Http.configure do |config|
            config.enabled = false
          end
          expect(I18n).to receive(:original_translate).and_return(translation)
          expect(I18n::Http).not_to receive(:new).with(:en)
        end

        it 'calls through to original_translate without modifying its arguments and returns the translation' do
          expect(I18n.translate(key)).to eq(translation)
        end
      end

      context 'when config is enabled' do
        before do
          I18n::Http.configure do |config|
            config.enabled = true
          end
          expect(I18n).not_to receive(:original_translate)
          request_object = double(I18n::Http::Request)
          expect(I18n::Http::Request).to receive(:new).with(:en).and_return(request_object)
          expect(request_object).to receive(:call).and_return(en_response)
        end

        it 'call the request and returns the translation' do
          expect(I18n.translate('hello')).to eq('Hello')
        end

        it 'call the request and returns the translation missing' do
          expect(I18n.translate('hi')).to eq("translation missing: en.hi")
        end
      end

      context 'when config is enabled and no response' do
        before do
          I18n::Http.configure do |config|
            config.enabled = true
          end
          request_object = double(I18n::Http::Request)
          expect(I18n::Http::Request).to receive(:new).with(:en).and_return(request_object)
          expect(request_object).to receive(:call).and_return(nil)
          expect(I18n).to receive(:original_translate).and_return(translation)
        end

        it 'calls through to original_translate without modifying its arguments and returns the translation' do
          expect(I18n.translate('hello')).to eq(translation)
        end
      end
    end

    context "when locale and default_locale is different" do
      before do
        I18n.locale = :de
      end
  
      context 'when config is enabled' do
        before do
          I18n::Http.configure do |config|
            config.enabled = true
          end
          expect(I18n).not_to receive(:original_translate)
          request_object = double(I18n::Http::Request)
          expect(I18n::Http::Request).to receive(:new).with(:de).and_return(request_object)
          expect(request_object).to receive(:call).and_return(de_response)
        end

        it 'call the request and returns the translation' do
          expect(I18n.translate('hello')).to eq('Hallo')
        end
      end

      context 'when fallback is true' do
        before do
          I18n::Http.configure do |config|
            config.enabled = true
          end
          request_object = double(I18n::Http::Request)
          expect(I18n::Http::Request).to receive(:new).with(:de).ordered.and_return(request_object)
          expect(I18n::Http::Request).to receive(:new).with(:en).ordered.and_return(request_object)
          expect(request_object).to receive(:call).and_return(de_response, en_response)
          # expect(I18n).to receive(:original_translate).and_return(translation)
        end

        it 'calls default locale request and returns the translation' do
          expect(I18n.translate('welcome', fallback: true)).to eq('Welcome')
        end

        it 'calls through to original_translate without modifying its arguments and returns the translation' do
          expect(I18n.translate('welcome', fallback: true)).to eq('Welcome')
        end

        it 'call the request and returns the translation missing' do
          expect(I18n.translate('hi', fallback: true)).to eq("translation missing: de.hi")
        end
      end
    end
  end
end
