jQuery(document).on 'ready page:load', ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()
  $('a[data-toggle="tooltip"]').tooltip();

