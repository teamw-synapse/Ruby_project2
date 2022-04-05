var regexp =  /^(?:(?:https?|ftp):\/\/)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/\S*)?$/;

$(document).ready(function(){
  var target = document.querySelector('#branding_font_url');
  if (target != null) {
    target.addEventListener('paste', function(event){
      var url = event.clipboardData.getData('text');
      fonts = findFonts(url);
      return document.getElementById("branding_font_family").value = fonts;
    });

    target.addEventListener('change', function(event){
      var url = event.target.value;
      font_family_field = document.getElementById("branding_font_family")
      newFonts = findFonts(url);
      oldFonts = font_family_field.value;
      if (url == "" || !regexp.test(url)){
        return font_family_field.value = "";
      }
      if (newFonts != oldFonts){
        return font_family_field.value = newFonts;
      }
    });
  }
		
  //Multi Select Agency in Branding Form
  $("#branding_agency_ids").multiselect().multiselectfilter();
});

function findFonts(url){
  if (!regexp.test(url)) return null
  var fontFamilies = getFontsName('family', url)
  if (!fontFamilies) return null
  var fontArr = [];
  fontFamilies.split('|').forEach(function(item) {
    fontArr.push(item.split(':')[0]);
  });
  var fonts = fontArr.join(', ');
  return fonts
}

function getFontsName(name, url) {
  if (!url) url = window.location.href;
  name = name.replace(/[\[\]]/g, "\\$&");
  var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
      results = regex.exec(url);
  if (!results) return null;
  if (!results[2]) return '';
  return decodeURIComponent(results[2].replace(/\+/g, " "));
}
