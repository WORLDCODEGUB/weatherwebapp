# --- Stage 1: Build ---
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# 1. Copy POM
COPY pom.xml .

# 2. Create Maven folder structure
RUN mkdir -p src/main/java
RUN mkdir -p src/main/webapp/WEB-INF

# 3. Copy Java Source Code
# Moves src/MyPackage -> src/main/java/MyPackage
COPY src/ src/main/java/

# 4. Copy Web Content (HTML/JSP/CSS)
# Moves WebContent files -> src/main/webapp
COPY WebContent/ src/main/webapp/

# 5. GENERATE web.xml AUTOMATICALLY (Single Line Version)
# This creates the file that connects your Button to your Java Code
RUN echo '<?xml version="1.0" encoding="UTF-8"?><web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="4.0"><display-name>Weather App</display-name><welcome-file-list><welcome-file>index.jsp</welcome-file></welcome-file-list><servlet><servlet-name>WeatherServlet</servlet-name><servlet-class>MyPackage.MyServlet</servlet-class></servlet><servlet-mapping><servlet-name>WeatherServlet</servlet-name><url-pattern>/MyServlet</url-pattern></servlet-mapping></web-app>' > src/main/webapp/WEB-INF/web.xml

# 6. Build the application
RUN mvn clean package

# --- Stage 2: Run ---
FROM tomcat:9.0-jdk17-temurin

# Clean existing apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Fix Render Port Issue
RUN sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# Copy the built app to ROOT (so it loads at the main URL)
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
