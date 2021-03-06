const { environment } = require('@rails/webpacker')

module.exports = environment

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    //$: 'admin-lte/plugins/jquery/jquery',
    //jQuery: 'admin-lte/plugins/jquery/jquery',
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    Popper: 'popper.js',
    moment: 'moment/moment'
  })
)
