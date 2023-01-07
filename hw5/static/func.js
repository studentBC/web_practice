// document.getElementsByClassName("clickMe").onclick = submitlol;

function submitlol() {
    var kw = document.forms["partOne"]["kw"].value;
    var loc = document.forms["partOne"]["location"].value;
    var elems = document.getElementsByClassName("searchResult");
    for (var i = 0; i < elems.length; i++) elems[i].style.display = 'flex';
}

function cc() {
    document.forms["partOne"].reset();
}