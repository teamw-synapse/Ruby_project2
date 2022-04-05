$(document).ready(function() {

  $("#resource_show_info").on("change", toggleShowInfoResources);

  $("#high").sortable({
    update: function(e, ui) {
      $.ajax({
        url: $(this).data("url"),
        method: "PATCH",
        data: $(this).sortable('serialize'),
      });
    }
  });

  $(".copy_template").click(function(e) {
    e.preventDefault()
    var id = $("#resource_resource_template_list").val();
    if (id !== "") {
      fetchResource(id);
    }
  });

  $("#resource_template").on("change", hideNonResourceTemplateFields);
  $("#resource_image").on("change", hideImg);

  $("#resource_image").on("change",function() {
    var reader = new FileReader();
    reader.onload = function(e) {
      // get loaded data and render thumbnail.
      $("#resource_img").attr("src", e.target.result);
      $("#resource_img").show();
      $('#resource_image').css('color', 'black');
    };
    // read the image file as a data URL.
    reader.readAsDataURL(this.files[0]);
  });

});

function hideImg() {
  var img = $('#resource_image').val();
  if (img !== "") {
    $('#resource_img').hide();
    $('#resource_image').css('color', 'black');
  }
}

function hideNonResourceTemplateFields() {
  var checked = $("#resource_template").prop("checked");
  if (checked) {
    $("#resource_agency_ids_input, #resource_highlight_input, #resource_global_input, #resource_username_input, #resource_password_input").hide();
  } else {
    $("#resource_agency_ids_input, #resource_highlight_input, #resource_global_input, #resource_username_input, #resource_password_input").show();
  }
}

var fetchResource = function(id) {
  $.ajax({
    method: 'GET',
    url: '/admin/resources/' + id + ".json",
    success: function(data) {
      $('#resource_title').val(data.title);
      $('#resource_url').val(data.url);
      $('#resource_description').val(data.description);
      $('#resource_template_image').val(data.image_url);
      $('#resource_img').attr('src', data.image_url);
      var tags = [];
      for (var i=0; i<data.tags.length; i++) {
        tags.push(data.tags[i].name);
      }
      tags = tags.join(",");
      $('.as-results').remove();
      $('#resource_image').val("");
      $('#resource_image').css('color', 'transparent');
      $('#resource_image').show();
      $('.as-selections').replaceWith("<input id='resource_tag_names' type='text' value='' name='resource[tag_names]'>");
      initializeResourceTagsAutoSuggest(tags);
    }
  });
}

function toggleShowInfoResources(){
    if($("#resource_show_info").prop("checked")){
      $('#add_resource_info').show();
    } else {
      $('#add_resource_info').hide();
    }
  }

