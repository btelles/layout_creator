$ ->
  window.App = Ember.Application.create()

  Plugin = Ember.Object.extend({
    type: 'generic',
    name: 'me'
  })

  App.firstPlugin = Plugin.create({
    name: "my first plugin's name"
  })

  $('a.settings').click( (evt)->
    $('.plugin_settings').dialog()
  )
