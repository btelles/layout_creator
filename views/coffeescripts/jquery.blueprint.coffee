$.fn.updateSpanSize = (stepsChanged) ->
  klasses = this.attr('class').split(' ')

  span  = _.find(klasses.reverse(), (el) ->
    el.match(/^span-\d*$/)
  )

  throw 'No blueprint span-# to update' unless span.match(/^span-\d*$/)

  currentSize = eval(span.match(/\d+/)[0])

  newSize = currentSize + Math.round(stepsChanged)

  $(this).removeClass(span).addClass('span-'+ newSize.toString())
