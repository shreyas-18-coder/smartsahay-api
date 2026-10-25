package com.smartsahay.util;

import com.smartsahay.service.AuthService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public final class AuthGuard {

    private AuthGuard() { }

    /** Returns true if the caller is an admin. Otherwise writes a 401 and returns false. */
    public static boolean requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String header = req.getHeader("Authorization");
        String token = null;
        if (header != null && header.startsWith("Bearer ")) {
            token = header.substring(7).trim();
        }
        if (!AuthService.isValid(token)) {
            resp.setHeader("WWW-Authenticate", "Bearer");
            JsonUtil.error(resp, 401, "Admin login required");
            return false;
        }
        return true;
    }
}