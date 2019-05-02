import urllib3
import certifi

http = urllib3.PoolManager(cert_reqs='CERT_REQUIRED', ca_certs=certifi.where())

company = "YOUR_TEAMWORK_SITE_NAME"
key = "YOUR_API_KEY"
action = "projects.json"

url = "https://{0}.teamwork.com/{1}".format(company, action)
headers = urllib3.util.make_headers(basic_auth=key + ":xxx")
request = http.request('GET', url, headers=headers)

response = request.status
data = request.data

print(data)
