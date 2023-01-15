import { Component, OnInit, ElementRef } from "@angular/core";
import { NgForm } from "@angular/forms";
import { HttpClient, HttpXsrfTokenExtractor } from "@angular/common/http"
// platformBrowserDynamic().bootstrapModule(ServerComponent);

declare global {
    var lat: 0;
    var long: 0;
    var res: 0;
    var jsobj: object;
    var jsonText: string;
    var ascending: boolean,
        prevCol: -1;
    var jsonObjArray: object[];
    var jsonStrArray: string[];
}

@Component({
    selector: 'app-server',
    templateUrl: './server.component.html',
    styleUrls: ['./server.component.css']
})
export class ServerComponent implements OnInit {
    /////////////// inital variable realted ////////////
    ngOnInit(): void {
        globalThis.ascending = true;
        globalThis.jsonObjArray = [];
        globalThis.jsonStrArray = [];
    }
    constructor(private http: HttpClient) {

    }
    initial(jojo: object) {
        console.log(typeof (jojo));
        console.log(jojo);
        globalThis.jsobj = jojo;
        globalThis.jsonObjArray.push(jojo);
        globalThis.jsonStrArray.push(JSON.stringify(jojo));
    }
    clickTab(id: string) {
        let tabs = document.getElementById("sea");
        let target = document.getElementById("mb");
        // tabs.classList.add('active');
        if (target) target.style.borderColor = 'transparent';
        if (tabs) tabs.style.borderColor = 'transparent';
        let t = document.getElementById(id);
        if (t) t.style.borderColor = 'black';
    }
    ///////////// clear button  ///////////////
    // cc() {
    //     document.getElementById("APIresult").innerHTML = '';
    //     // let elems = document.getElementsByClassName("APIresult");
    //     // for (let i = 0; i < elems.length; i++) elems[i].remove();
    //     elems = document.getElementsByClassName("searchResult");
    //     for (let i = 0; i < elems.length; i++) elems[i].style.display = "none";
    // }
    ///////////// handle submit button ///////////////
    httpGet(theUrl: string) {
        let xmlHttpReq = new XMLHttpRequest();
        xmlHttpReq.open("GET", theUrl, false);
        xmlHttpReq.send(null);
        return xmlHttpReq.responseText;
    }
    async callAPI(url: string) {
        console.log('enter callAPI');
        console.log(url);
        //nodeJS server IP
        await fetch('http://127.0.0.1:3000/getYelpSearch', {
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
                globalThis.jsonText = JSON.stringify(response);
                console.log(typeof (response));
                globalThis.jsobj = response;
                console.log(typeof (response));
                //console.log(JSON.stringify(response));
                return response;
            })
            .then(response => this.initial(response));
        console.log('---- come out ----');
        let jojo = JSON.parse(globalThis.jsonText);
        console.log(typeof (jojo));
        console.log(jojo.total);
        // console.log(jsonObjArray[0].total);
        let left = jojo.total - jojo.businesses.length, start = 50;
        if (left > 0) {
            while (left) {
                console.log(left);
                await fetch('http://127.0.0.1:3000/getYelpSearch', {
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
                    .then(response => this.initial(response))
                    .then(response => {
                        start += jojo.businesses.length;
                        let job = JSON.parse(globalThis.jsonStrArray[jsonStrArray.length-1]);
                        left -= job.businesses.length;
                    });
            }
        }
        console.log(jsonObjArray.length);
        this.createAPIresultTable();
        return;
    }
    // showPosition(position: JSON) {
    //     lat = position.coords.latitude;
    //     long = position.coords.longitude;
    //     console.log(lat);
    //     console.log(long);
    // }
    submitlol(form: NgForm): void {
        // console.log(event);
        //form submit will refresh my page and clear log
        // event.preventDefault();
        let kw = "",
            loc = "Taipei",
            selfLocate = false,
            fc = "Default",
            dist = 10;
        console.log(form.value);
        kw = form.value.kw || 'deli';
        loc = form.value.location || "Taipei";
        selfLocate = form.value.autoDetect || false;
        fc = form.value.fc || "Default";
        dist = form.value.dm || 10;
        console.log(loc);
        console.log(kw);
        console.log(selfLocate);
        console.log(fc);
        console.log(dist);
        let debug = true;

        if (!dist) dist = 10000;
        if (!fc) fc = "all";
        if (!selfLocate && loc === "") {
            alert("you has not enter all required info!");
            return;
        }
        if (selfLocate) {
            if (navigator.geolocation) {
                alert('selfLocate checked!');
                //navigator.geolocation.getCurrentPosition(showPosition);
            } else {
                alert("Geolocation is not supported by this browser.");
            }
        } else {
            if (!debug) {
            loc = loc.replace(/\s+/g, '+');
            var gkey = '';
            var gr = this.httpGet('https://maps.googleapis.com/maps/api/geocode/json?address=' + loc + '&key=' + gkey);
            //call python get method to get the address
            var res = JSON.parse(gr);
            globalThis.lat = res.results[0].geometry.location.lat;
            globalThis.long = res.results[0].geometry.location.lng;
            }
        }
        //call YELP https://docs.developer.yelp.com/reference/v3_business_search
        //let url = 'https://api.yelp.com/v3/businesses/search?term=delis&latitude=37.786882&longitude=-122.399972&offset=20&limit=50';
        let url = "";
        if (debug) {
            url = 'https://api.yelp.com/v3/businesses/search?term=delis&location=Austin&limit=50'
        } else {
             url = 'https://api.yelp.com/v3/businesses/search?term=' + kw + '&latitude=' + lat + '&longitude=' + long +
            '&categories=' + fc + '&radius=' + dist + '&limit=50';
        }
        this.callAPI(url);
    }
    ///////////// dynamically deal with webUI ///////////////
    createAPIresultTable() {
        console.log('enter to createAPIresultTable');
        //store json obj into data array
        var len = jsonObjArray.length;
        console.log(len);
        let data: any[] = [];
        if (len > 0) {
            console.log('enter to creat !!!');
            const elems = document.getElementsByClassName("APIresult");
            for (let i = 0; i < elems.length; i++) {
                const ee = elems[i] as HTMLElement;
                ee.style.display = 'flex';
            }
            let index = 1;
            console.log('------  here ------');
            for (let j = 0; j < len; j++) {
                console.log(jsonStrArray[j]);
                let jsonObj = JSON.parse(jsonStrArray[j]);
                console.log('jsonObj length is ' + jsonObj.businesses.length);
                for (let i = 0; i < jsonObj.businesses.length; i++) {
                    let tmp = [];
                    tmp.push(index);
                    if (jsonObj.businesses[i]?.image_url) tmp.push(jsonObj.businesses[i].image_url);
                    else tmp.push('http://clipart-library.com/images/dc45Exp9i.png');
                    if (jsonObj.businesses[i]?.name) tmp.push(jsonObj.businesses[i].name);
                    else tmp.push('fuck');
                    if (jsonObj.businesses[i]?.rating) tmp.push(jsonObj.businesses[i].rating);
                    else tmp.push(-1);
                    if (jsonObj.businesses[i]?.distance) tmp.push(jsonObj.businesses[i].distance);
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

        td3.addEventListener("click", () => this.sortColumn(data, 2));
        td4.appendChild(text4);
        td4.classList.add("rating");
        td4.addEventListener("click", () => this.sortColumn(data, 3));
        td5.appendChild(text5);
        td5.classList.add("dist");
        td5.addEventListener("click", () => this.sortColumn(data, 4));

        tr.appendChild(td1);
        tr.appendChild(td2);
        tr.appendChild(td3);
        tr.appendChild(td4);
        tr.appendChild(td5);

        table.appendChild(tr);
        console.log('before creating table ...');
        console.log('data length is ' + data.length);
        for (let i: number = 0; i < data.length; i++) {
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
            td3.addEventListener("click", () => this.moreInfo(data[i][2]));
            td4 = document.createElement('td');
            td4.classList.add("rating");
            td5 = document.createElement('td');
            td5.classList.add("dist");


            let num = i + 1;
            text1 = document.createTextNode(num.toString());
            let image = document.createElement('img');
            image.src = data[i][1];
            image.style.width = "150px";

            text3 = document.createTextNode(data[i][2]);
            text4 = document.createTextNode(data[i][3]);
            text5 = document.createTextNode(data[i][4]);

            td1.appendChild(text1);
            td2.appendChild(image);
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

    sortColumn(array: any, col: any) {
        if (globalThis.prevCol == col) globalThis.ascending = !globalThis.ascending;
        if (ascending) {
            array.sort(function (a: any, b: any) {
                var x = a[col];
                var y = b[col];
                return ((x < y) ? -1 : ((x > y) ? 1 : 0));
            });
        } else {
            array.sort(function (a: any, b: any) {
                var x = a[col];
                var y = b[col];
                return ((x < y) ? 1 : ((x > y) ? -1 : 0));
            });
        }
        let table = document.getElementById("APIresultTable") as HTMLTableElement;
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
        globalThis.prevCol = col;
    }
    //when user click the title and ask for more info
    moreInfo(name: string) {
        console.log('enter moreInfo');
        const elems = document.getElementsByClassName("searchResult");
        for (let i = 0; i < elems.length; i++) {
            const ee = elems[i] as HTMLElement;
            ee.style.display = 'flex';
        }

        for (let a = 0; a < jsonObjArray.length; a++) {
            let jsobj = JSON.parse(jsonStrArray[a]);
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
                    let tmp =document.getElementById("pn") as HTMLElement;
                    if (jsobj.businesses[i].phone ) {
                        tmp.innerHTML = jsobj.businesses[i].phone;
                    } else {
                        tmp.innerHTML = "None";
                    }
                    tmp = document.getElementById("address") as HTMLElement;
                    tmp.innerHTML = addr;

                    for (let j = 0; j < jsobj.businesses[i].transactions.length; j++) {
                        trs += jsobj.businesses[i].transactions[j];
                        trs += " ";
                    }
                    console.log(trs);
                    tmp = document.getElementById("transactionsSupported") as HTMLElement;
                    if (trs.length) {
                        tmp.innerHTML = trs;
                    } else {
                        tmp.innerHTML = "None";
                    }
                    for (let j = 0; j < jsobj.businesses[i].categories.length; j++) {
                        cate += jsobj.businesses[i].categories[j].alias;
                        cate += " ";
                    }

                    console.log(cate);
                    let lol = document.getElementById("categories") as HTMLElement;
                    lol.textContent = cate;
                    //for more info
                    //var anchor = document.createElement('a');
                    let anchor = document.getElementById("minfo") as HTMLAnchorElement;
                    //var anchorText = document.createTextNode('Yelp');
                    anchor.href = jsobj.businesses[i].url;
                    //anchor.setAttribute('href', jsobj.businesses[i].url);
                    break;
                }
            }
        }
    }
}