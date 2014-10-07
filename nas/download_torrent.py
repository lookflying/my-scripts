#!/usr/bin/python
import requests
cookies = dict(bgPicName="Default", c_expiresintv="0", c_secure_uid="MzY0Mw%3D%3D", c_secure_pass="7b87894fa24bed43c370715170fcf48e", c_secure_ssl="eWVhaA%3D%3D", c_secure_login="bm9wZQ%3D%3D", __utmt="1", __utma="248584774.159802578.1409997105.1412675485.1412678192.25", __utmb="248584774.32.10.1412678192", __utmc="248584774",)
r = requests.get("https://pt.sjtu.edu.cn/viewusertorrents.php?&id=3643&show=completed", cookies=cookies, stream=True)
#r = requests.get("https://pt.sjtu.edu.cn/download.php?id=47975", cookies=cookies, stream=True)
if r.status_code == 200:
#    print r.headers
    print r.text
