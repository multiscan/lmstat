jQuery(document).on 'ready page:load', ->
  jQuery('.edit_feature input[type=submit]').remove()
  jQuery('.edit_feature input[type=checkbox]').click ->
    $(this).parent('form').submit()
