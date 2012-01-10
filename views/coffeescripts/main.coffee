$ ->

  editorMethods =
    show: (evt) ->
      $(this).find('.menu').show()

    hide: (evt) ->
      $(this).find('.menu').hide()

  pluginMethods = 
    showCurrentPlugin: (evt) ->
      plugin = $.plugins()[$(this).attr('href').replace(/#/,'')]
      style = plugin.style
      title = plugin.title
      text = plugin.text
      $('.plugin .preview').html("<div class='plugin_preview'><h3 style='#{style}'>#{plugin.title}</h3><div class='plugin_icon'><p class='caption'>(click to select)</p><p>#{text}</p></div>")

  layoutMethods =
    splitV:
      horizontalOffset: 40
      changeSpanSize: (evt, ui) ->
        stepsChanged = (ui.position.left - ui.originalPosition.left) / 40
        currentGrid  = $(this).closest('[class*=span-]')
        nextGrid  = currentGrid.next('[class*=span-]')
        $(currentGrid).updateSpanSize(stepsChanged)
        $(nextGrid).updateSpanSize(- stepsChanged)
        currentGrid.find('.split-v').css('left', '')

  config =
    hoverIntent:
      timeout: 400
      over: editorMethods.show
      out: editorMethods.hide
    splitV:
      axis: 'x'
      grid: [layoutMethods.splitV.horizontalOffset,0]
      stop: layoutMethods.splitV.changeSpanSize

  $('.picker > div').hoverIntent( config.hoverIntent )
  $('.plugin .menu ul li a').live('mouseover', pluginMethods.showCurrentPlugin)
  $('.grid .split-v').draggable(config.splitV)

  $('#colorSelector').ColorPicker( color: '#0000ff',
    onShow: (colorPicker)->
      $(colorPicker).fadeIn(500)
      return false
    onHide: (colorPicker) ->
      $(colorPicker).fadeOut(500)
      return false
    onChange: (hsb, hex, rgb) ->
      $('#colorSelector div').css('backgroundColor', '#' + hex)
  )
