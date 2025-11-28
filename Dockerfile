FROM nginx:alpine

# 1. Remove the default Nginx "Welcome" page so it doesn't confuse us
RUN rm -rf /usr/share/nginx/html/*

# 2. Copy the CONTENTS of the 'WebContent' folder to the Nginx root
# Note: Ensure you run the docker build command from the folder CONTAINING 'WebContent'
COPY WebContent/ /usr/share/nginx/html

# 3. Expose port 80
EXPOSE 80

# 4. Start Nginx
CMD ["nginx", "-g", "daemon off;"]
