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

  showChangePluginDialog: (evt) ->
    $('.ui-dialog-content').dialog('close')
    $('#change_plugin').dialog('open')

PluginManager =
  showCurrentPlugin: (evt) ->
    plugin = $.plugins()[$(this).attr('href').replace(/#/,'')]
    style = plugin.style
    title = plugin.title
    text = plugin.text
    $('#change_plugin .preview').html("<div class='plugin_preview'><h3 style='#{style}'>#{plugin.title}</h3><div class='plugin_icon'><p class='caption'>(click to select)</p><p>#{text}</p></div>")

  selectedPlugin: (elem) ->
    elem.attr('href').replace(/#/,'')

  selectPlugin: (evt) ->
    newPluginType = PluginManager.selectedPlugin($(this))
    Editor.changeCurrentPluginTo(newPluginType)

$ ->
  methods =
    savePage: ->

    updateTemplate: ->
      PM.template.updateWith($(this).val())


  PM.template.restore()

  $('.template_chooser').live('change', methods.updateTemplate)

  $('.layout_button, .content_button, .preview_button').live('click', Editor.showPanel)

  #Dialogs
  $('#save').dialog({autoOpen: false, title: "You've saved the page."})
  $('#publish').dialog({autoOpen: false, title: "You've published the page."})
  $('#change_plugin').dialog({autoOpen: false, title: "Change the selected Plugin", width: 500, minHeight: 530})

  #Clicks
  $('.save_button').live('click', PM.template.save)
  $('.publish_button').live('click', PM.template.publish)
  $('.plugin_editor').live('click', Editor.editPlugin)
  $('.layout_editor').live('click', Editor.editLayout)
  $('a.delete_plugin').live('click', Editor.deleteCurrentPlugin)
  $('a.change_plugin').live('click', Editor.showChangePluginDialog)
  $('.menu ul li a').live('mouseover', PluginManager.showCurrentPlugin)
  $('#sidebar_tabs').tabs()
