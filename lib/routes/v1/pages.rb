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

        before do
          page_identifier = request.path_info.split('/')[2]
          pass unless page_identifier
          @page = Page.find_by(name: page_identifier)
          halt 404, msg("Resource doesn't exist.") if @page.nil?
        end

        get '/pages/?' do
          pages = Page.order(updated_at: :desc)
          PageRepresenter.for_collection.prepare(pages).to_json
        end

        get '/pages/:name/?' do
          PageRepresenter.prepare(@page).to_json
        end

        private

        def msg(message)
          {msg: message}.to_json
        end

      end
    end
  end
end
