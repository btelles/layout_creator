PM =
  templateContent: ->
    localStorage.getItem('page_template')

  template:
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

    publish: ->
      $('#publish').dialog('open')

    save: ->
      preview = $('#preview')
      localStorage.setItem('page_template', preview.html())
      $('#save').dialog('open')

    restore: (name)->
      content = localStorage.getItem('page_template')
      if content != null
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
    Editor.currentPlugin = $(this).closest('.plugin')

  editLayout: (evt) ->
    Editor.openLayoutDialogFor(this)

  deleteCurrentPlugin: (evt) ->
    Editor.deletePlugin(Editor.currentPlugin)

  deletePlugin: (plugin) ->
    pluginType = Editor.pluginType($(plugin))
    pluginId   = Editor.pluginId($(plugin))
    $('#layout, #preview, #content')
      .find('.'+pluginId)
      .removeClass(pluginType)
      .empty()
    PM.template.save

  pluginId: (plugin) ->
    pluginIds = $.grep($(plugin).attr('class').split(' '), (item) ->
      item.match(/plugin_\d*/)
    )
    pluginIds.join(',')

$ ->
  methods =
    savePage: ->

    updateTemplate: ->
      PM.template.updateWith($(this).val())


  PM.template.restore()

  $('.template_chooser').live('change', methods.updateTemplate)

  $('.layout_button, .content_button, .preview_button').live('click', Editor.showPanel)
  $('#save').dialog({autoOpen: false, title: "You've saved the page."})
  $('#publish').dialog({autoOpen: false, title: "You've published the page."})
  $('a.delete_plugin').live('click', Editor.deleteCurrentPlugin)

