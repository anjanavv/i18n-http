module I18n
  module Http
    class Configuration
      attr_accessor :enabled, :endpoint

      def initialize
        @enabled = nil
        @endpoint = nil
      end

    end
  end
end