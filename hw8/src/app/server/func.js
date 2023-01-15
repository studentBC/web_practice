// document.getElementsByClassName("clickMe").onclick = submitlol;
let lat = 0,
    long = 0,
    res, jsobj, ascending = true,
    prevCol = -1;
let jsonObjArray = [];
//////////////deal with front-end 


function httpGet(theUrl) {
    let xmlHttpReq = new XMLHttpRequest();
    xmlHttpReq.open("GET", theUrl, false);
    xmlHttpReq.send(null);
    return xmlHttpReq.responseText;
}

function initial(jojo) {
    jsobj = jojo;
    jsonObjArray.push(jojo);
}
async function callAPI(url) {
    console.log('enter callAPI');
    await fetch('http://127.0.0.1:5000/getYelpSearch', {
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
        .then(response => {
            console.log(JSON.stringify(response));
            return response;
        })
        .then(response => initial(response))
    // .then(response => createAPIresultTable(response))
    // .then(response => {
    console.log(jsobj.total);
    console.log(jsonObjArray[0].total);
    let left = jsobj.total - jsobj.businesses.length;
    if (left > 0) {
        let last = left % 50,
            start = 50;
        while (left) {
            await fetch('http://127.0.0.1:5000/getYelpSearch', {
                    method: 'POST',
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        "url": url + '&offset=' + start
                    })
                })
                .then(response => response.json())
                .then(response => initial(response))
                .then(response => {
                    start += jsobj.businesses.length;
                    left -= jsobj.businesses.length;
                });
        }
    }
    console.log(jsonObjArray.length);
    createAPIresultTable();
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
    if (!dist) dist = 10000;
    if (!fc) fc = "all";
    if (!selfLocate && loc === "") {
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
        var gkey = '';
        var gr = httpGet('https://maps.googleapis.com/maps/api/geocode/json?address=' + loc + '&key=' + gkey);
        //call python get method to get the address
        var res = JSON.parse(gr);
        lat = res.results[0].geometry.location.lat;
        long = res.results[0].geometry.location.lng;
    }
    //call YELP https://docs.developer.yelp.com/reference/v3_business_search
    //let url = 'https://api.yelp.com/v3/businesses/search?term=delis&latitude=37.786882&longitude=-122.399972&offset=20&limit=50';
    let url = 'https://api.yelp.com/v3/businesses/search?term=' + kw + '&latitude=' + lat + '&longitude=' + long +
        '&categories=' + fc + '&radius=' + dist + '&limit=50';
    callAPI(url);


    // });

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

function sortColumn(array, col) {
    if (prevCol == col) ascending = !ascending;
    if (ascending) {
        array.sort(function (a, b) {
            var x = a[col];
            var y = b[col];
            return ((x < y) ? -1 : ((x > y) ? 1 : 0));
        });
    } else {
        array.sort(function (a, b) {
            var x = a[col];
            var y = b[col];
            return ((x < y) ? 1 : ((x > y) ? -1 : 0));
        });
    }
    let table = document.getElementById("APIresultTable");
    for (let i = 1; i < array.length; i++) {
        console.log(array[i][0]);
        console.log(table.rows[i].cells[1].innerHTML);
        //the image is not inner text so we need to change it!
        //table.rows[i].cells[1].innerText = array[i][1];
        table.rows[i].cells[1].innerText = "";
        let img = document.createElement('img');
        img.style.width = "150px";
        img.src = array[i][1];
        table.rows[i].cells[1].appendChild(img);
        //the business name still need to show its link
        table.rows[i].cells[2].innerText = array[i][2];
        table.rows[i].cells[3].innerText = array[i][3];
        table.rows[i].cells[4].innerText = array[i][4];
    }
    prevCol = col;
}

function createAPIresultTable() {
    console.log('enter to createAPIresultTable');
    //store json obj into data array
    var len = jsonObjArray.length;
    console.log(len);
    let data = [];
    if (len > 0) {
        console.log('enter to creat !!!');
        const elems = document.getElementsByClassName("APIresult");
        for (let i = 0; i < elems.length; i++) elems[i].style.display = 'flex';
        let index = 1;
        for (let j = 0; j < len; j++) {
            let jsonObj = jsonObjArray[j];
            console.log('jsonObj length is ' + jsonObj.businesses.length);
            for (let i = 0; i < jsonObj.businesses.length; i++) {
                let tmp = [];
                tmp.push(index);
                if (jsonObj.businesses[i] ?.image_url) tmp.push(jsonObj.businesses[i].image_url);
                else tmp.push('http://clipart-library.com/images/dc45Exp9i.png');
                if (jsonObj.businesses[i] ?.name) tmp.push(jsonObj.businesses[i].name);
                else tmp.push('fuck');
                if (jsonObj.businesses[i] ?.rating) tmp.push(jsonObj.businesses[i].rating);
                else tmp.push(-1);
                if (jsonObj.businesses[i] ?.distance) tmp.push(jsonObj.businesses[i].distance);
                else tmp.push(-1);
                data.push(tmp);
                index++;
            }
        }
        console.log('data length is ' + data.length);
    }
    var table = document.createElement('table');
    table.setAttribute("id", "APIresultTable");
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
    //td1.addEventListener("click", ()=>sortColumn(0));
    td2.appendChild(text2);
    td2.classList.add("img");
    //td2.addEventListener("click", ()=>sortColumn(1));
    td3.appendChild(text3);
    td3.classList.add("bn");

    td3.addEventListener("click", () => sortColumn(data, 2));
    td4.appendChild(text4);
    td4.classList.add("rating");
    td4.addEventListener("click", () => sortColumn(data, 3));
    td5.appendChild(text5);
    td5.classList.add("dist");
    td5.addEventListener("click", () => sortColumn(data, 4));

    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3);
    tr.appendChild(td4);
    tr.appendChild(td5);

    table.appendChild(tr);
    console.log('before creating table ...');
    console.log('data length is ' + data.length);
    for (let i = 0; i < data.length; i++) {
        tr = document.createElement('tr');
        tr.classList.add("arow");
        td1 = document.createElement('td');
        td1.classList.add("no");
        td2 = document.createElement('td');
        td2.classList.add("img");
        //let nav3 = document.createElement('nav');
        //we shall create <nav> </nav>
        // nav3.classList.add("nav-link");
        td3 = document.createElement('td');
        td3.classList.add("bn");
        console.log('');
        // td3.classList.add("nav");
        //creating a function which will not be executed immediately => moreinfo.bind(null, jsonObj.businesses[i].name)
        //td3.addEventListener("click", moreInfo.bind(null, jsonObj.businesses[i].name));
        td3.addEventListener("click", () => moreInfo(data[i][2]));
        td4 = document.createElement('td');
        td4.classList.add("rating");
        td5 = document.createElement('td');
        td5.classList.add("dist");



        text1 = document.createTextNode(i + 1);
        text2 = document.createElement('img');
        //text2.src = jsonObj.businesses[i].image_url;
        text2.src = data[i][1];
        text2.style.width = "150px";
        // text3 = document.createTextNode(jsonObj.businesses[i].name);
        // text4 = document.createTextNode(jsonObj.businesses[i].rating);
        // text5 = document.createTextNode(jsonObj.businesses[i].distance);
        text3 = document.createTextNode(data[i][2]);
        text4 = document.createTextNode(data[i][3]);
        text5 = document.createTextNode(data[i][4]);
        // console.log(jsonObj.businesses[i].name);
        // console.log(jsonObj.businesses[i].rating);
        // console.log(jsonObj.businesses[i].distance);
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
    console.log('after creating table ...');
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
    document.getElementById("APIresult").innerHTML = '';
    // let elems = document.getElementsByClassName("APIresult");
    // for (let i = 0; i < elems.length; i++) elems[i].remove();
    elems = document.getElementsByClassName("searchResult");
    for (let i = 0; i < elems.length; i++) elems[i].style.display = "none";
}
//when user click the title and ask for more info
function moreInfo(name) {
    console.log('enter moreInfo');
    const elems = document.getElementsByClassName("searchResult");
    for (let i = 0; i < elems.length; i++) elems[i].style.display = 'flex';

    for (let a = 0; a < jsonObjArray.length; a++) {
        let jsobj = jsonObjArray[a];
        for (let i = 0; i < jsobj.businesses.length; i++) {
            if (name === jsobj.businesses[i].name) {
                var addr = "",
                    trs = "",
                    cate = "";
                for (let j = 0; j < Object.keys(jsobj.businesses[0].location.display_address).length; j++) {
                    addr += jsobj.businesses[j].location.display_address[j];
                    addr += " ";
                }
                console.log(addr);
                //document.getElementById("address").textContent = addr;
                if (jsobj.businesses[i].phone) document.getElementById("pn").innerHTML = jsobj.businesses[i].phone;
                else document.getElementById("pn").innerHTML = "None";
                //document.getElementById("pn").textContent = jsobj.businesses[i].phone;
                document.getElementById("address").innerHTML = addr;

                for (let j = 0; j < jsobj.businesses[i].transactions.length; j++) {
                    trs += jsobj.businesses[i].transactions[j];
                    trs += " ";
                }
                console.log(trs);
                if (trs.length) document.getElementById("transactionsSupported").innerHTML = trs;
                else document.getElementById("transactionsSupported").innerHTML = "None";
                for (let j = 0; j < jsobj.businesses[i].categories.length; j++) {
                    cate += jsobj.businesses[i].categories[j].alias;
                    cate += " ";
                }

                console.log(cate);
                document.getElementById("categories").textContent = cate;
                //for more info
                //var anchor = document.createElement('a');
                let anchor = document.getElementById("minfo");
                //var anchorText = document.createTextNode('Yelp');
                anchor.href = jsobj.businesses[i].url;
                //anchor.setAttribute('href', jsobj.businesses[i].url);
                break;
            }
        }
    }
}