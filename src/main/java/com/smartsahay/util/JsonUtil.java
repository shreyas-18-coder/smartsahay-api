package com.smartsahay.util;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonParseException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Map;

public final class JsonUtil {

    private static final Gson GSON = new GsonBuilder().disableHtmlEscaping().create();

    private JsonUtil() { }

    public static void send(HttpServletResponse resp, int status, Object body) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(GSON.toJson(body));
    }

    public static void error(HttpServletResponse resp, int status, String message) throws IOException {
        send(resp, status, Map.of("error", message));
    }

    public static <T> T read(HttpServletRequest req, Class<T> type) throws IOException, JsonParseException {
        req.setCharacterEncoding("UTF-8");
        try (BufferedReader reader = req.getReader()) {
            return GSON.fromJson(reader, type);
        }
    }
}