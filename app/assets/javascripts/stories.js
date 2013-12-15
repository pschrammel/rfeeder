//hide new flag when klicked
Rfeeder.wire_open_story = function () {
  $("#stories").on('click', ".js-open-story", function () {
    var indicator_id = "#new-story-" + $(this).data("new-story-id");
    $(indicator_id).hide();
  })
};

Rfeeder.wire_mark_all_read = function () {
  $(".js-mark-all-read").click(function () {
    $(".js-new-story-indicator").hide();
  })
};


Rfeeder.wire_mark_read = function () {
  $("#stories").on('click', ".js-new-story-indicator", function () {
    $(this).hide();
  })
};

