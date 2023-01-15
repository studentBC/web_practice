const express = require('express');
const app = express();
app.use(express.json());

function SendRequest(datatosend) {
    function OnResponse(response) {
        var data = '';

        response.on('data', function(chunk) {
            data += chunk; //Append each chunk of data received to this variable.
        });
        response.on('end', function() {
            console.log(data); //Display the server's response, if any.
        });
    }

    var request = http.request(urlparams, OnResponse); //Create a request object.

    request.write(datatosend); //Send off the request.
    request.end(); //End the request.
}
async function callAPI(url) {
    let res;
    let api_key = '';
    await fetch(url, {
        method: 'GET',
        headers: {
            'Accept': 'application/json',
            'Authorization': api_key,
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(response => {
        res = response;
        // console.log(response);
        console.log(JSON.stringify(response));
        // return response;
    });
    return res;
}
app.post('/getYelpSearch', async function(request, response) {
    console.log('node JS was called ...');
    let jObj = request.body;
    console.log('node JS was called ...');
    console.log(jObj);
    let url = jObj.url;
    console.log(url);
    let jbody = await callAPI(url);
    console.log(jbody);
    response.send(jbody);
    // app.get(url, function(req, res) {
    //     console.log(req.headers);
    //     req.headers['Authorization'] = 'Bearer %s' % api_key;
    //     req.pipe(request(url)).pipe(res);
    //     console.log(res.body);
    //     response.headers['Access-Control-Allow-Origin'] = '*';
    //     response.send(res.body);
    //     return res.body;
    // });
    // let resHeader = {
    //     'Access-Control-Allow-Origin': '*',
    //     'Content-Type': 'application/json'
    // }
    //response.headers['Access-Control-Allow-Origin'] = '*';
    //response.headers = resHeader;
    // response.send('cannot get Yelp Data man ...');
})
app.get('/', (req, res) => {
    console.log(req.body);
    res.send('<h1> Hola !</h1>');
})
app.listen(3000);