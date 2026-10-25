package com.smartsahay.servlet;

import com.google.gson.JsonParseException;
import com.smartsahay.service.AuthService;
import com.smartsahay.util.JsonUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

@WebServlet("/api/admin/login")
public class AdminLoginServlet extends HttpServlet {

    private static class LoginRequest {
        String username;
        String password;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        LoginRequest body;
        try {
            body = JsonUtil.read(req, LoginRequest.class);
        } catch (JsonParseException e) {
            JsonUtil.error(resp, 400, "Request body is not valid JSON");
            return;
        }
        if (body == null || body.username == null || body.password == null) {
            JsonUtil.error(resp, 400, "username and password are required");
            return;
        }

        String token = AuthService.login(body.username, body.password);
        if (token == null) {
            JsonUtil.error(resp, 401, "Invalid username or password");
            return;
        }
        JsonUtil.send(resp, 200, Map.of(
                "token", token,
                "tokenType", "Bearer",
                "expiresInSeconds", AuthService.TOKEN_TTL_SECONDS));
    }
}