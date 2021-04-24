# README

This README would normally document whatever steps are necessary to get the
application up and running.


<img width="600"  src="https://user-images.githubusercontent.com/6063541/115592199-e5c92880-a30d-11eb-80f8-ba896fd0dd32.png">


# setup

```
$ bundle install --path vendor/bundle
$ bundle exec rails new . --skip-action-mailer --skip-active-storage --skip-action-cable 
$ bundle install --path vendor/bundle  
```

## yarn

```
$ yarn install --check-files
$ yarn add admin-lte@3.0.5
$ yarn add jquery
$ yarn add popper.js
$ yarn add @fortawesome/fontawesome-free
$ yarn add font-awesome
$ yarn add toastr
$ yarn add tempusdominus-bootstrap-4
$ yarn add jquery-ui
```

## AdminLTE, toast

- app/asset/stylesheets/application.css
```
何も記述しない
```

- app/javascript/packs/application.js
```
require('jquery')
require('jquery-ui')
require("jquery-ui/ui/widgets/autocomplete")
require("admin-lte")
require("moment/locale/ja")
require("tempusdominus-bootstrap-4")

global.toastr = require("toastr")
import 'bootstrap'
import "../stylesheets/application"

import "@fortawesome/fontawesome-free/js/all";
import 'jquery-ui/themes/base/core.css';
import 'jquery-ui/themes/base/menu.css';
import 'jquery-ui/themes/base/autocomplete.css';
import 'jquery-ui/themes/base/theme.css'; 
```

- app/javascript/stylesheets/application.scss
```
@import 'toastr';
@import 'admin-lte';
@import 'bootstrap';
@import '@fortawesome/fontawesome-free';
@import "~tempusdominus-bootstrap-4/src/sass/tempusdominus-bootstrap-4";
```

- app/config/webpack/environment.js
```
const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'admin-lte/plugins/jquery/jquery',
    jQuery: 'admin-lte/plugins/jquery/jquery',
    moment: 'moment/moment'
  })
)
```

- app/helpers/application_helper.rb
```
module ApplicationHelper

  def toastr_flash
    flash.each_with_object([]) do |(type, message), flash_messages|
      type = 'success' if type == 'notice'
      type = 'error' if type == 'alert'
      text = "<script>toastr.#{type}('#{message}', '', { closeButton: true, progressBar: true })</script>"
      flash_messages << text.html_safe if message
    end.join("\n").html_safe
  end

end
```

- app/views/admin/layouts/application.html.erb
```
    <%= yield %>
    <%= toastr_flash %>
```
