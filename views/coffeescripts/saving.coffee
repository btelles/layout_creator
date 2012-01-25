PM = {}
PM.template =
  name: 'basic'

  addNewContent: ->
    me = this
    $.get('/templates/'+ this.name, (data) ->
      $('#preview, #layout, #content').append( data )
      me.updatePlugins()
    )

  updatePlugins: ->
    $('#preview .plugin').each( (item) ->
      pluginClass   = $(this).attr('class').split(' ')[1]
      pluginContent = $('#hidden_plugins .'+ pluginClass + '_plugin').html()
      $(this).append(pluginContent)
    )

  updateWith: (name)->
    this.name= name
    $('#preview, #layout, #content').empty()
    this.addNewContent()

$ ->
  methods =
    savePage: ->
      preview = $('#preview')
      content = preview.html()
      templateName = preview.find('> div').attr('id')
      PM.saveCurrentTemplate(templateName, content)

    updateTemplate: ->
      PM.template.updateWith($(this).val())


  $('.save_button').live('click', methods.savePage)

  $('.template_chooser').live('change', methods.updateTemplate)
