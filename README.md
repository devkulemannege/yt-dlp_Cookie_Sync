<h1 align="left">
  Container-based Cookie Updater for yt-dlp
  <img src="assets\Vector.png" width="50" align="right" />
</h1>

**Automatically retrieves YouTube cookies via Playwright for yt-dlp in a Docker/serverless setup.**

## Overview
This project provides an automated solution to update YouTube cookies which are required by yt-dlp when running on an automated isolated system.
Installation and start-up will be controlled by the included `Dockerfile`. The main Python code is `Flask` based works by listening at `Port 8080` using `Gunicorn`. 

## Features 
- Gunicorn listens to `Port 8080` at `0.0.0.0`
- Simple HTML button on default route `/` to test functionality
- `/run_container` activates upon receving a `POST` request
- Automatic cookie format conversion from JSON to Netscape
- Uses Xvfb (X virtual framebuffer) as a display server to run non-headless browser in serverless service
<br>
- **Additional Feature**
    It is possible to run this program **without** the Docker solution. How to do this...
    1. Define your Google Account credentials in [creds.env](creds.env).
⚠️ **Warning:** Do **not** use a personal account. Always use a dummy/test account.
    2. Install Python libraries 
    ```python
    pip install -r requirements.txt
    ```
    3. Write the following into a separate .py file...
    ```python
    from playwright.async_api import async_playwright
    import logging
    import dotenv
    import asyncio
    import os
    
    dotenv.load_dotenv('creds.env')
    EMAIL = os.getenv('EMAIL')
    PASSWORD = os.getenv('PASSWORD')
    COOKIE_FILE_NAME = os.getenv('COOKIE_FILE_NAME')

    async def update_execute():
        '''add code inside of function here (line 51 - 104 in updater.py)'''
    asyncio.run(update_execute()) # start async function
    ```
    and that's it!

#### How it Works...
1. **Sign in** → Uses the provided Google Account credentials.  
2. **Autofill** → Automatically fills in Gmail and password.  
3. **Redirect** → Navigates to YouTube after login.  
4. **Extract Cookies** → Retrieves cookies in **JSON format** using Playwright.  
5. **Convert Format** → Converts cookies from JSON to **Netscape format** for yt-dlp compatibility.  
6. **Export & Log** → Saves cookies to `cookiefile.txt` and prints them in logs.  

## How to Get Started
#### Setting Up
1. Prepare a serverless service to run Docker containers
    - Ex:- Google Cloud Run (recommended), Railway, Vercel
    During testing, Google Cloud Run worked with no problems. When using other platforms Google might detect the signing in process as a **potential threat**.
<br>
2. Define your Google Account credentials in [creds.env](creds.env).
⚠️ **Warning:** Do **not** use a personal account. Always use a dummy/test account.
<br>
3. Setup the service to run on `port 8080`. If needed, please edit the port setting or remove it accordingly on line 113
```python
app.run(host="0.0.0.0", port=int(os.getenv("PORT", 8080))) 
```
#### Starting the Application
 1. The service should be setup to build using the Dockerfile
<br>
 2. Use a trigger or a valid method to send a `POST` request to route `/run_container` from an external source in order to start the cookie updater
    - **Note:** The entire process takes ~50 seconds (depends on service) to complete. Configure the trigger/external source to wait for 1 - 5 minutes to prevent multiple `POST` requests, which will result in a loop.
<br>
3. Once the application is done running, it will show an output of the cookiefile.txt as a log and await for another `POST` request.

## Contributions
Contributions are welcome! If you'd like to improve this project:

- Fork the repo
- Create a new branch
- Open a pull request with your changes

Please ensure your code is clean and documented where needed.

