# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
# added on 4jul clpied from https://stackoverflow.com/questions/70639662/actioncontrollerroutingerror-no-route-matches-get-assets-rails-actiontex
pin '@rails/activestorage', to: 'activestorage.esm.js'
pin 'local-time' # @2.1.0
pin 'trix'
pin '@rails/actiontext', to: 'actiontext.js'

pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true

pin_all_from 'app/javascript/channels', under: 'channels'
pin_all_from 'app/javascript/controllers', under: 'controllers'
