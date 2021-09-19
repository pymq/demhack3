#!/usr/bin/env python
# coding: utf-8

# !pip install selenium
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import InvalidSessionIdException
from selenium.webdriver.common.keys import Keys
from bs4 import BeautifulSoup 
import time
import requests
import json
import zipfile
import requests
import io



def download_extract_zip(url):
    """
    Download a ZIP file and extract its contents in memory
    yields (filename, file-like object) pairs
    """
    response = requests.get(url)
    with zipfile.ZipFile(io.BytesIO(response.content)) as thezip:
        for zipinfo in thezip.infolist():
            with thezip.open(zipinfo) as thefile:
                yield zipinfo.filename, thefile
                
                
def get_final_extensionInnerPageUrl(ext_id,extensionInnerPageUrl):
    for i in download_extract_zip(extensionInnerPageUrl):
        if i[0].endswith('.js') or i[0].endswith('.css'):
            extensionInnerPageUrl_result = f"chrome-extension://{ext_id}/{i[0]}"
            return extensionInnerPageUrl_result
    return ''


def main():
    chrome_options = Options()
    chrome_options.headless = True
    driver = webdriver.Chrome(executable_path='D:/Users/Поиск/Downloads/chromedriver_win32/chromedriver.exe',
                              options=chrome_options
                             )
    #extention list url
    url = 'https://chrome.google.com/webstore/category/ext/1-communication?hl=ru'
    driver.get(url)
    counter = 0
    while counter < 10:
        counter = counter+1
        driver.find_element_by_tag_name('body').send_keys(Keys.END) #scroll up to the end of page
        time.sleep(1)
    html = driver.page_source
    # WebDriverWait(driver, timeout).until(html)
    soup_extention = BeautifulSoup(html)

    data = {}
    data['extentions'] = []
    for a in soup_extention.find_all('a'):
        if ('a-u' in a["class"]):
            ext_url = a.get('href')
            ext_id = ext_url.split('/')[-1].split('?')[0]
            ext_icon = a.img.get('src')
            ext_title = a.find("div", {"class": "a-P-d-w"}).get('title')
            print(ext_title)
            if 'span' in a:
                ext_title_ = a.span.get('title')
                print(ext_title_)
                print('\n')
            else:
                ext_title_=''
            extensionInnerPageUrl = f"https://clients2.google.com/service/update2/crx?response=redirect&prodversion=49.0&acceptformat=crx3&x=id%3D{ext_id}%26installsource%3Dondemand%26uc"
            final_extensionInnerPageUrl = get_final_extensionInnerPageUrl(ext_id,extensionInnerPageUrl)
        
            data['extentions'].append({
                'name': ext_title,
                'name_': ext_title_,
                'id': ext_id,
                'icon': ext_icon,
                'extensionInnerPageUrl': final_extensionInnerPageUrl
            })

    with open('json_extentions_data.txt', 'w') as outfile:
        json.dump(data, outfile)

main()