package MyPackage;

package com.weather;

import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

@WebServlet("/MyServlet")
public class MyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Debug: Check if Servlet is reached
        System.out.println("--- MyServlet has been called! ---");
        
        String city = request.getParameter("city");
        String apiKey = "ab056d5abf5c755be575fefc3e929eb8"; // <--- PASTE KEY HERE !!!
        String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid=" + apiKey + "&units=metric";

        try {
            URL url = new URL(apiUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            
            // 2. Debug: Check API Response Code
            int responseCode = connection.getResponseCode();
            System.out.println("API Response Code: " + responseCode);

            if (responseCode == 200) {
                InputStreamReader reader = new InputStreamReader(connection.getInputStream());
                Scanner scanner = new Scanner(reader);
                StringBuilder responseContent = new StringBuilder();
                while (scanner.hasNext()) {
                    responseContent.append(scanner.nextLine());
                }
                scanner.close();

                Gson gson = new Gson();
                JsonObject jsonObject = gson.fromJson(responseContent.toString(), JsonObject.class);
                
                // 3. Debug: Print JSON data
                System.out.println("Weather Data Found: " + jsonObject.toString());

                double temp = jsonObject.getAsJsonObject("main").get("temp").getAsDouble();
                int humidity = jsonObject.getAsJsonObject("main").get("humidity").getAsInt();
                double windSpeed = jsonObject.getAsJsonObject("wind").get("speed").getAsDouble();
                String weatherCondition = jsonObject.getAsJso
