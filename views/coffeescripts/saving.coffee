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
    $('#preview .plugin, #layout .plugin, #content .plugin').each( (item) ->
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
  prepareLayout: ->
    $('#layout .plugin').append("<p class='layout_editor'>Edit Layout</p>") unless $('#layout .plugin .layout_editor').size() > 0

  prepareContent: ->
    $('#content .plugin').append("<p class='plugin_editor'>Edit Plugin</p>") unless $('#content .plugin .plugin_editor').size() > 0

  pluginType: (item) ->
    classes = $(item).closest('.plugin').attr('class').split(' ')
    pluginClass = classes.indexOf('plugin')
    classes[pluginClass + 1]

  openPluginDialogFor: (pluginType) ->
    $('#edit_plugin').load('/plugin_dialogs/generic', ->
      $('#edit_plugin').dialog({title: "Settings for "+pluginType+" plugin"})
      $('#edit_plugin').dialog('open')
    )

  openLayoutDialogFor: (layoutItem) ->
    $('#edit_layout').load('/layout_dialogs/generic', ->
      $('#edit_layout').dialog({title: "Layout Settings" })
      $('#edit_layout').dialog('open')
    )

  showPanel: (evt) ->
    panelToShow = $(this).attr('class').replace(/_button/, '')
    $('#layout, #content, #preview').hide()
    $('#'+panelToShow).show()
    Editor.prepareLayout() if panelToShow == 'layout'
    Editor.prepareContent() if panelToShow == 'content'

  pluginDialog: ->
    $('#edit_plugin').dialog(
      autoOpen: false
    )
  layoutDialog: ->
    $('#edit_layout').dialog(
      autoOpen: false
    )

  editPlugin: (evt) ->
    pluginType = Editor.pluginType(this)
    Editor.openPluginDialogFor(pluginType)

  editLayout: (evt) ->
    Editor.openLayoutDialogFor(this)

$ ->
  methods =
    savePage: ->

    updateTemplate: ->
      PM.template.updateWith($(this).val())


  $('.save_button').live('click', PM.template.save)

  $('.template_chooser').live('change', methods.updateTemplate)

  $('.layout_button, .content_button, .preview_button').live('click', Editor.showPanel)
  $('.plugin_editor').live('click', Editor.editPlugin)
  $('.layout_editor').live('click', Editor.editLayout)
