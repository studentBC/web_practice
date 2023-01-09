from flask import Flask, redirect, url_for, request, render_template
import json, requests

app = Flask(__name__)

@app.route("/")
def index():
    return render_template('index.html')

#deal with yelp search 
#https://www.codespeedy.com/how-to-pass-javascript-variables-to-python-in-flask/
@app.route('/getYelpSearch', methods=['POST', 'GET'])
def getYelpSearch():
    print('enter getYelpSearch')
    url = request.get_json()
    print(type(url))
    print(url['url'])
    api_key = ''

    headers = {
        'Authorization': 'Bearer %s' % api_key,
    }
    response = requests.request('GET', url['url'], headers=headers)
    #print(response.json())
    return response.json()


    # print('get url', url)
    # url = json.loads(url)
    res = requests.get(url['url'])
    print(res.json)
    return Response(
        res.json,
        status=res.status_code,
        content_type=res.headers['content-type']
    )

if __name__ == '__main__':
   app.run(debug = True)
