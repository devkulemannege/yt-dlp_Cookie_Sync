FROM python:3

WORKDIR /app

# install dependencies for playwright 
RUN apt-get update && apt-get install -y \
xvfb \
libnspr4 \
libnss3 \
libdbus-1-3 \
libatk1.0-0t64 \
libatk-bridge2.0-0t64 \
libcups2t64 \
libxkbcommon0 \
libatspi2.0-0t64 \
libxcomposite1 \
libxdamage1 \
libxfixes3 \
libxrandr2 \
libgbm1 \
libasound2t64

# install required python libraries 
COPY requirements.txt ./
RUN pip install -r requirements.txt

# download ONLY chromium & chrome with relevant dependencies 
RUN playwright install-deps chromium && playwright install chrome

COPY . .

# expose port 8080 for docker. Change this if necessary
ENV PORT=8080
EXPOSE 8080

# start x display BEFORE executing python file
CMD Xvfb :99 -screen 0 1024x768x24 & export DISPLAY=:99 && gunicorn --bind 0.0.0.0:8080 updater:app

