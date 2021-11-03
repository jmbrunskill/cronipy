FROM python:3

RUN apt-get --allow-releaseinfo-change-suite update
#Install Cron & supervisord
RUN apt-get -y install cron supervisor procps dos2unix

#Setup SSHD to allow remote access via azure app service
#Root password must be hardcoded for Azure App Service login to work
RUN apt install -y openssh-server
RUN echo "root:Docker!" | chpasswd 
COPY sshd_config /etc/ssh/
RUN mkdir -p /var/run/sshd 
RUN chmod 0755 /var/run/sshd

WORKDIR /usr/src/app

#Restore any required python libraries
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

#Copy all our code to the working directory (you may want to be a little more specific)
COPY . .

#Mark executable scripts as executable (and make sure they are in unix format)
RUN dos2unix example_cron_job.sh
RUN chmod +x example_cron_job.sh
RUN dos2unix python_server.sh
RUN chmod +x python_server.sh

#Register the cron jobs with cron
RUN dos2unix application.crontab
RUN crontab application.crontab

#Azure App Service requires SSH logins to be using port 2222
EXPOSE 2222

#Azure App Service defaults to port 80 for the http server (can be changed using the WEBSITES_PORT app setting)
EXPOSE 80

#Supervisor will start both cron and the python server (as configured in supervisord.conf)
CMD ["/usr/bin/supervisord", "-c", "/usr/src/app/supervisord.conf"]