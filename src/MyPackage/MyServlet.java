package MyPackage;

import java.io.IOException;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/MyServlet")
public class MyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public MyServlet() { super(); }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("--- BUTTON CLICKED: MyServlet was called! ---");
        
        String city = request.getParameter("city");
        
        // --- TEST MODE: BYPASS API ---
        // We will send fake data just to see if the UI updates.
        
        request.setAttribute("date", new Date());
        request.setAttribute("city", city + " (Test Mode)");
        request.setAttribute("temperature", 25);
        request.setAttribute("weatherCondition", "Clear");
        request.setAttribute("humidity", 50);
        request.setAttribute("windSpeed", 10.5);
        
        // Forward to JSP
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
