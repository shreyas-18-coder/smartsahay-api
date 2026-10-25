package com.smartsahay.servlet;

import com.smartsahay.util.AuthGuard;
import com.smartsahay.util.JsonUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

@WebServlet("/api/admin/session")
public class AdminSessionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!AuthGuard.requireAdmin(req, resp)) {
            return;
        }
        JsonUtil.send(resp, 200, Map.of("authenticated", true));
    }
}