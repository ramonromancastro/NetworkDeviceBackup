function myFunction() {
  var input, filter, table, tr, td, i;
  input = document.getElementById('myInput');
  filter = input.value.toUpperCase();
  table = document.getElementById("myTable");
  tr = table.getElementsByTagName('tr');
  for (i = 0; i < tr.length; i++) {
	td = tr[i].getElementsByTagName('td')[0];
	if (td) {
	  if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
		tr[i].style.display = '';
	  } else {
		tr[i].style.display = 'none';
	  }
	}       
  }
}

var slideIndex = 0;

function carousel() {
	var i;
	var x = document.getElementsByClassName("my-slide");
	for (i = 0; i < x.length; i++) {
	  x[i].style.display = "none";
	}
	slideIndex++;
	if (slideIndex > x.length) {slideIndex = 1}
	x[slideIndex-1].style.display = "block";
	setTimeout(carousel, 10000); // Change image every 10 seconds
}

// When the user scrolls down 20px from the top of the document, show the button
window.onscroll = function() {scrollFunction()};

function scrollFunction() {
    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
        document.getElementById("myBtn").style.display = "block";
    } else {
        document.getElementById("myBtn").style.display = "none";
    }
}

// When the user clicks on the button, scroll to the top of the document
function topFunction() {
    document.body.scrollTop = 0;
    document.documentElement.scrollTop = 0;
}