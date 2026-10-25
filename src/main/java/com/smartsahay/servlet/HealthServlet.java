package com.smartsahay.servlet;

import com.google.gson.Gson;
import com.smartsahay.util.DBConnection;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/api/health")
public class HealthServlet extends HttpServlet {

    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("status", "UP");
        body.put("service", "SmartSahay API");

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM schemes")) {
            rs.next();
            body.put("database", "UP");
            body.put("schemesCount", rs.getInt(1));
        } catch (SQLException e) {
            getServletContext().log("Database health check failed", e);
            resp.setStatus(503);
            body.put("status", "DEGRADED");
            body.put("database", "DOWN");
        }

        resp.getWriter().write(gson.toJson(body));
    }
}