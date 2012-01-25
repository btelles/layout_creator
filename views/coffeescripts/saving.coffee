PM = {}
PM.template =
  name: 'basic'

  addNewContent: ->
    me = this
    $.get('/templates/'+ this.name, (data) ->
      $(Editor.allPanels).append( data )
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
    $(Editor.allPanels).empty()
    this.addNewContent()

  save: ->
    preview = $('#preview')
    localStorage.setItem('page_template', preview.html())

  restoreTemplate: (name)->
    content = localStorage.getItem('page_template')
    $(Editor.allPanels).append(content)

Editor =
  allPanels: '#preview, #layout, #content'
  showPanel: (evt) ->
    panelToShow = $(this).attr('class').replace(/_button/, '')
    $('#layout, #content').hide()
    $('#'+panelToShow).show()
    # this.prepareLayout() if panelToShow == 'layout'
    # this.prepareContent() if panelToShow == 'content'

  prepareLayout: ->
    $('#layout .plugin').append("<p class='layout_editor'>Edit Layout</p>")
  prepareContent: ->
    $('#content .plugin').append("<p class='plugin_editor'>Edit Plugin</p>")


$ ->
  methods =
    savePage: ->

    updateTemplate: ->
      PM.template.updateWith($(this).val())


  $('.save_button').live('click', PM.template.save)

  $('.template_chooser').live('change', methods.updateTemplate)

  $('.layout_button, .content_button, .preview_button').live('click', Editor.showPanel)
