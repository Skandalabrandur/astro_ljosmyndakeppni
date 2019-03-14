function previewImage(input) { 
  if (input.files && input.files[0]) { 
    console.log(input.files[0]);
    var reader = new FileReader(); 
 
    reader.onload = function (e) { 
      var extension = input.files[0].name.substring(input.files[0].name.lastIndexOf('.') + 1);
      console.log(extension);
      if((input.files[0].size / (1000*1000)) > 50.0) {
        $('#submitter').hide();
        alert("Hámarksstærð leyfileg er 50MB. Þín mynd er:" + (input.files[0].size / (1000*1000)) + "MB");
      } else if(extension != "jpg" && extension != "jpeg" && extension != "png") {
        $('#submitter').hide();
        alert('Mynd þarf að vera .jpg, .jpeg eða .png');
      } else {
        $('#submitter').show();
        $('#prev-img') 
        .attr('src', e.target.result) 
        //.width(150) 
        .height(200); 
      }
    }; 
 
    reader.readAsDataURL(input.files[0]); 
  } 
}

