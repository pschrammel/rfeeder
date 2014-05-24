//hide new flag when klicked
Rfeeder.wire_open_story = function () {
  $("#stories").on('click', ".js-open-story", function () {
    var indicator_id = "#new-story-" + $(this).data("new-story-id");
    $(indicator_id).hide();
  })
};

Rfeeder.wire_mark_all_read = function () {
  $(".js-mark-all-read").click(function () {
    $(".js-new-story-indicator").find('.storyNotRead').removeClass("storyNotRead");
  })
};


Rfeeder.wire_mark_read = function () {
  $("#stories").on('click', ".js-new-story-indicator", function () {
    $(this).bind('ajax:before', function () {
      $(this).data('params', { toggle: 'true' })
    });
    $(this).bind('ajax:success', function (data, textStatus, jqXHR) {

      if (textStatus.opened) {
        $(this).find('.read-story').removeClass("storyNotRead");
      } else {
        $(this).find('.read-story').addClass("storyNotRead");
      }
    });

  })
};

Rfeeder.wire_mark_read_later = function () {
  $("#stories").on('click', ".js-read-later-story-indicator", function () {
    $(this).bind('ajax:before', function () {
      $(this).data('params', { toggle: 'true' })
    });
    $(this).bind('ajax:success', function (data, textStatus, jqXHR) {
      if (textStatus.read_later) {
        $(this).find('.read-later').removeClass("storyNotReadLater");
      } else {
        $(this).find('.read-later').addClass("storyNotReadLater");
      }
    });

  })
};

