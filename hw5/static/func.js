// document.getElementsByClassName("clickMe").onclick = submitlol;
var lat = 0,
    long = 0,
    res;

function httpGet(theUrl) {
    let xmlHttpReq = new XMLHttpRequest();
    xmlHttpReq.open("GET", theUrl, false);
    xmlHttpReq.send(null);
    return xmlHttpReq.responseText;
}

function submitlol(event) {
    console.log(event);
    //form submit will refresh my page and clear log
    event.preventDefault();
    var kw = "",
        loc = "Taipei",
        selfLocate = false,
        fc = "Default",
        dist = 10;
    kw = document.forms["partOne"]["kw"].value;
    loc = document.forms["partOne"]["location"].value;
    selfLocate = document.forms["partOne"]["autoDetect"].checked;
    fc = document.forms["partOne"]["fc"].value;
    dist = document.forms["partOne"]["dm"].value;
    if (!dist) dist = 10;
    if (!fc) fc = "Default";
    if (!selfLocate && loc == "") {
        alert("you has not enter all required info!");
        return false;
    }
    if (selfLocate) {
        if (navigator.geolocation) {
            alert('selfLocate checked!');
            navigator.geolocation.getCurrentPosition(showPosition);
        } else {
            alert("Geolocation is not supported by this browser.");
        }
    } else {
        loc = loc.replace(/\s+/g, '+');
        var gkey = ''
        var gr = httpGet('https://maps.googleapis.com/maps/api/geocode/json?address=' + loc + '&key=' + gkey);
        //call python get method to get the address
        var res = JSON.parse(gr);
        lat = res.results[0].geometry.location.lat;
        long = res.results[0].geometry.location.lng;
    }
    //call YELP https://docs.developer.yelp.com/reference/v3_business_search
    //url = 'https://api.yelp.com/v3/businesses/search?term=delis&latitude=37.786882&longitude=-122.399972';
    url = 'https://api.yelp.com/v3/businesses/search?term=' + kw + '&latitude=' + lat + '&longitude=' + long +
        '&categories=' + fc + '&radius=' + dist;
    fetch('http://127.0.0.1:5000/getYelpSearch', {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                "url": url
            })
        })
        .then(response => response.json())
        .then(response => createAPIresultTable(response))
        .then(response => console.log(JSON.stringify(response)));
    // .then(response => res = JSON.parse(response));
    // if (res) {
    //     console.log(res["total"]);
    //     console.log(res.total);
    //     //alert(JSON.stringify(res));
    // } else alert('we dont receive res');
    // createAPIresultTable(res);
    //show the search result block
    // var elems = document.getElementsByClassName("APIresult");
    // for (var i = 0; i < elems.length; i++) elems[i].style.display = 'flex';


}

function createAPIresultTable(jsonObj) {
    console.log('enter to createAPIresultTable');
    //console.log('enter to createAPIresultTable');
    var len = String(jsonObj.total);
    console.log(len);
    if (len > 0) {
        var elems = document.getElementsByClassName("APIresult");
        for (var i = 0; i < elems.length; i++) elems[i].style.display = 'flex';
    }
    var table = document.createElement('table');
    var tr = document.createElement('tr');
    var td1 = document.createElement('td');
    var td2 = document.createElement('td');
    var td3 = document.createElement('td');
    var td4 = document.createElement('td');
    var td5 = document.createElement('td');

    var text1 = document.createTextNode('No.');
    var text2 = document.createTextNode('Image');
    var text3 = document.createTextNode('Business Name');
    var text4 = document.createTextNode('Rating');
    var text5 = document.createTextNode('Distance(miles)');
    tr.classList.add("arow");
    td1.appendChild(text1);
    td1.classList.add("no");
    td2.appendChild(text2);
    td2.classList.add("img");
    td3.appendChild(text3);
    td3.classList.add("bn");
    td4.appendChild(text4);
    td4.classList.add("rating");
    td5.appendChild(text5);
    td5.classList.add("dist");

    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3);
    tr.appendChild(td4);
    tr.appendChild(td5);

    table.appendChild(tr);
    for (var i = 0; i < len; i++) {
        tr = document.createElement('tr');
        tr.classList.add("arow");
        td1 = document.createElement('td');
        td1.classList.add("no");
        td2 = document.createElement('td');
        td2.classList.add("img");
        td3 = document.createElement('td');
        td3.classList.add("bn");
        td4 = document.createElement('td');
        td4.classList.add("rating");
        td5 = document.createElement('td');
        td5.classList.add("dist");

        text1 = document.createTextNode(i + 1);
        text2 = document.createElement('img');
        text2.src = jsonObj.businesses[i].image_url;
        text2.style.width = "150px";
        text3 = document.createTextNode(jsonObj.businesses[i].name);
        text4 = document.createTextNode(jsonObj.businesses[i].rating);
        text5 = document.createTextNode(jsonObj.businesses[i].distance);
        console.log(jsonObj.businesses[i].name);
        console.log(jsonObj.businesses[i].rating);
        console.log(jsonObj.businesses[i].distance);
        td1.appendChild(text1);
        td2.appendChild(text2);
        td3.appendChild(text3);
        td4.appendChild(text4);
        td5.appendChild(text5);

        tr.appendChild(td1);
        tr.appendChild(td2);
        tr.appendChild(td3);
        tr.appendChild(td4);
        tr.appendChild(td5);

        table.appendChild(tr);
    }
    document.getElementsByClassName("APIresult")[0].appendChild(table);
}

function showPosition(position) {
    lat = position.coords.latitude;
    long = position.coords.longitude;
    console.log(lat);
    console.log(long);
}

function cc() {
    document.forms["partOne"].reset();
}