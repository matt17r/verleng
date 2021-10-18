module.exports = {
  mode: 'jit',
  purge: [
    './app/views/**/*.html.erb',
    './app/views/**/*.html.haml',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ]
}
