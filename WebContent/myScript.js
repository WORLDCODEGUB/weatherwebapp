var weatherStatus = document.getElementById("wc").value;
var weatherIcon = document.getElementById("weather-icon");

if (weatherStatus) {
    // Just a basic check to ensure the image changes
    if (weatherStatus.includes("Cloud")) {
        weatherIcon.src = "https://cdn-icons-png.flaticon.com/512/1146/1146869.png";
    } else if (weatherStatus.includes("Rain")) {
        weatherIcon.src = "https://cdn-icons-png.flaticon.com/512/3351/3351979.png";
    } else if (weatherStatus.includes("Clear")) {
        weatherIcon.src = "https://cdn-icons-png.flaticon.com/512/6974/6974833.png";
    } else {
        weatherIcon.src = "https://cdn-icons-png.flaticon.com/512/1163/1163624.png";
    }
}
