# --- Stage 1: Build the Java Application ---
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package

# --- Stage 2: Run Tomcat ---
FROM tomcat:9.0-jdk17-temurin

# 1. Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# 2. IMPORTANT FIX: Disable the Tomcat Shutdown Port (8005) 
# This stops the "Invalid shutdown command" error on Render
RUN sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# 3. Copy the WAR file we built in Stage 1
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# 4. Expose the web port
EXPOSE 8080

# 5. Start Tomcat
CMD ["catalina.sh", "run"]
