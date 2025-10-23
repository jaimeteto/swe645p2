FROM tomcat:9.0-jdk15
RUN rm -rf /usr/local/tomcat/webapps/*
COPY StudentSurvey.war /usr/local/tomcat/webapps/StudentSurvey.war
EXPOSE 8080
