import { Component, OnInit, ElementRef } from "@angular/core";
import {NgForm} from "@angular/forms";
import {HttpClient} from "@angular/common/http"
// platformBrowserDynamic().bootstrapModule(ServerComponent);

declare global {
    var lat: 0;
    var long: 0;
    var res: 0;
    var jsobj: JSON;
    var ascending: true,
    prevCol: -1;
    var jsonObjArray: [JSON];
}

@Component({
    selector: 'app-server',
    templateUrl: './server.component.html',
    styleUrls: ['./server.component.css']
})
export class ServerComponent implements OnInit{
    /////////////// inital variable realted ////////////
    ngOnInit(): void {
        
    }
    constructor(private http: HttpClient) {

    }
    initial(jojo: JSON) {
        globalThis.jsobj = jojo;
        jsonObjArray.push(jojo);
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
        // this.http.post('http://127.0.0.1:3000/getYelpSearch', {'url': url}).subscribe (
        //     res=>{
        //         console.log(res);
        //         //this.initial(res);
        //         //JSON.parse(res);
        //     }
        // );

        console.log('------- go next ---------');
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
                globalThis.jsobj = response;
                console.log(typeof(response));
                console.log(JSON.stringify(response));
                return response;
            })
            .then(response => this.initial(response));
        console.log('---- come out ----');
        // .then(response => createAPIresultTable(response))
        // .then(response => {
        // console.log(globalThis.jsobj.total);
        // console.log(jsonObjArray[0].total);
        // let left = globalThis.jsobj.total - globalThis.jsobj.businesses.length;
        // if (left > 0) {
        //     let last = left % 50,
        //         start = 50;
        //     while (left) {
        //         await fetch('http://127.0.0.1:5000/getYelpSearch', {
        //                 method: 'POST',
        //                 headers: {
        //                     'Accept': 'application/json',
        //                     'Content-Type': 'application/json'
        //                 },
        //                 body: JSON.stringify({
        //                     "url": url + '&offset=' + start
        //                 })
        //             })
        //             .then(response => response.json())
        //             .then(response => this.initial(response))
        //             .then(response => {
        //                 start += globalThis.jsobj.businesses.length;
        //                 left -= globalThis.jsobj.businesses.length;
        //             });
        //     }
        // }
        // console.log(jsonObjArray.length);
        // this.createAPIresultTable();
        return;
    }
    // showPosition(position: JSON) {
    //     lat = position.coords.latitude;
    //     long = position.coords.longitude;
    //     console.log(lat);
    //     console.log(long);
    // }
    submitlol(form: NgForm):void {
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
            loc = loc.replace(/\s+/g, '+');
            var gkey = '';
            var gr = this.httpGet('https://maps.googleapis.com/maps/api/geocode/json?address=' + loc + '&key=' + gkey);
            //call python get method to get the address
            var res = JSON.parse(gr);
            globalThis.lat = res.results[0].geometry.location.lat;
            globalThis.long = res.results[0].geometry.location.lng;
        }
        //call YELP https://docs.developer.yelp.com/reference/v3_business_search
        //let url = 'https://api.yelp.com/v3/businesses/search?term=delis&latitude=37.786882&longitude=-122.399972&offset=20&limit=50';
        let url = 'https://api.yelp.com/v3/businesses/search?term=' + kw + '&latitude=' + lat + '&longitude=' + long +
            '&categories=' + fc + '&radius=' + dist + '&limit=50';
        this.callAPI(url);
    }
}