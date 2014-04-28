jQuery ->
  loadCommit = (message, callback) ->
    json = JSON.parse(message.data)
    jQuery.ajax json.url,
      complete: (response) ->
        callback(json.id, response.responseText)

  onUpdate = (message) ->
    loadCommit message, (id, commit) ->
      $("#commit-#{id}").html(commit)

  onCreate = (message) ->
    loadCommit message, (id, commit) ->
      $("ul.commit-lst").prepend(commit)

  onRemove = (message) ->
    json = JSON.parse(message.data)
    $("#commit-#{json.id}").remove()

  $('[data-event-stream]').each ->
    url = $(this).data('event-stream')
    source = new EventSource(url)
    source.addEventListener 'commit.update', onUpdate
    source.addEventListener 'commit.create', onCreate
    source.addEventListener 'commit.remove', onRemove

