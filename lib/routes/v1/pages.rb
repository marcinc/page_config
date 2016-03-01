module PageConfig
  module Routes
    module V1
      class Pages < Sinatra::Application

        before do
          unless request.accept?('application/json')
            halt 406, msg('Invalid Accept header.')
          end
        end

        before do
          content_type 'application/json'
        end

        get '/pages/?' do
          pages = Page.order(updated_at: :desc)
          PageRepresenter.for_collection.prepare(pages).to_json
        end

        private

        def msg(message)
          {msg: message}.to_json
        end

      end
    end
  end
end
