//hide new flag when klicked
Rfeeder.wire_open_story = function () {
  $('.js-open-story').click(function(){
    var indicator_id="#new-story-"+$(this).data("new-story-id");
    $(indicator_id).hide();
  })
}