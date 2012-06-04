---
categories: python
tags: python, lastfm, urllib
date: 2012/05/31 00:00:00
title: Calling last.fm with python
---

Recently I had to get data for one of the projects. It's music-related webapp,
and we desperately needed some rock stars data in it. Well, maybe not so
desperately, but anyway. Just in time, my friend and collegue remembered about
[last.fm](last.fm). Yeah, they have tons of rock stars and .. well, free API.

API is really easy to use. In case you don't want to spend your time on
writing a client for it and you're using python, you can use mine. It's right
here, on [github](https://github.com/filipovskii/lastfm-python-api).

## Mechanica Viscera

#### Applying for API

As I said, API is really simple and so is the client. Let me dive into details,
so it would be *deadly obvious*.

For using lastfm API, you have to somehow tell them about your app. Do it
by [applying to API account](http://www.last.fm/api/account). Once you're
done, you should have `API_KEY` and `SECRET`. Replace Xs in `api.py` with
given values. I'll show, why we need it later.

$$code(lang=python)
ROOT_URL = 'http://ws.audioscrobbler.com/2.0/'
API_KEY = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
SECRET = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
$$/code

#### Calling API, without interacting with user

To get data, that does not require any user confirmation, you should simply
send GET request with specific parameters. There is a function for building
URLs for such requests:

$$code(lang=python)
def _make_request_url(**kwargs):
    """Create URL for regular GET request"""
    url = ROOT_URL + '?'
    kwargs['format'] = 'json'
    url += urllib.urlencode(kwargs)
    return url
$$/code

It creates an URL for GET request to ROOT\_URL and maps all parameters,
passed to the function as request parameters. We are expecting JSON, that's
why `format` parameter is there.

To send request call this:
$$code(lang=python)
def _call_lastfm_api(method_name, **method_args):
    """Call lastfm method with given parameters, return result JSON"""
    method_args['api_key'] = API_KEY
    method_args['method'] = method_name
    url = _make_request_url(**method_args)
    response_str = urllib2.urlopen(url).read()
    return json.loads(response_str)
$$/code

Yep, just pass *method_name*, *method_args* (except `api_key`, it's added
inside the function), and get JSON back..

Here are two examples, that use this functions: 

$$code(lang=python)
def get_top_artists_for_user(username):
    """Call *user.getTopArtists* method.

    Description: http://www.last.fm/api/show/user.getTopArtists
    """
    return _call_lastfm_api('user.getTopArtists', user=username)

def get_artist_info(artist_name):
    """Call *artist.getInfo* method.
    
    Description: http://www.last.fm/api/show/artist.getInfo
    """
    return _call_lastfm_api('artist.getInfo',
                            # non-ascii chars not supported..
                            artist=artist_name.encode('utf-8'))
$$/code

#### User authorization

I personally did not use any methods in the API, that require authorization,
but I've wrote some code, so you could do it.

First, you have to create a session for user. There is a `create_session()`
method for that. The most valuable part of it looks like this:

$$code(lang=python, style=monokai)
token_url = _make_request_url(method='auth.gettoken',
                          api_key=API_KEY)
token_response = urllib.urlopen(token_url)
token = json.loads(token_response.read())['token']

webbrowser.open('http://www.last.fm/api/auth/?api_key={}&token={}'
            .format(API_KEY, token))
print('Authorize request in your browser, then press Enter')
raw_input()

session_req_url = _make_signed_request_url(
    method='auth.getsession',
    token=token, api_key=API_KEY)

session_response = urllib2.urlopen(session_req_url)
$$/code

Here is what happening step by step:

1.  Get *token* from lastfm. Token is a temporary artifact, needed to
    distinguish session requests.
2.  Using this token, request user approval, by pointing him to the browser.
3.  Once user approved it, we can request *session_key*. This key can be used
    to make requests on behalf of user and has no expiration date.

There is also some code, that deals with saving and reading *session_key* and
lastfm *username* from file. It's not very interesting, so I'll just skip it.


