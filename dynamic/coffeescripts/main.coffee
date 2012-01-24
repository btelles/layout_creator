$ ->
  $('#preview .plugin').each( (item) ->
    pluginClass   = $(this).attr('class').split(' ')[1]
    pluginContent = $('#hidden_plugins .'+ pluginClass + '_plugin').html()
    $(this).append(pluginContent)
  )
