package com.smartsahay.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashSet;
import java.util.Properties;
import java.util.Set;

@WebFilter("/api/*")
public class CorsFilter implements Filter {

    private final Set<String> allowedOrigins = new HashSet<>();

    @Override
    public void init(FilterConfig config) throws ServletException {
        Properties props = new Properties();
        try (InputStream in = CorsFilter.class.getClassLoader().getResourceAsStream("app.properties")) {
            if (in != null) {
                props.load(in);
            }
        } catch (IOException e) {
            throw new ServletException("Could not read app.properties", e);
        }
        for (String origin : props.getProperty("cors.allowed.origins", "").split(",")) {
            if (!origin.isBlank()) {
                allowedOrigins.add(origin.trim());
            }
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String origin = req.getHeader("Origin");
        boolean allowed = origin != null && allowedOrigins.contains(origin);

        if (allowed) {
            resp.setHeader("Access-Control-Allow-Origin", origin);
            resp.setHeader("Vary", "Origin");
            resp.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
            resp.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
            resp.setHeader("Access-Control-Max-Age", "3600");
        }

        if ("OPTIONS".equalsIgnoreCase(req.getMethod())) {
            resp.setStatus(allowed ? HttpServletResponse.SC_OK : HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        chain.doFilter(request, response);
    }
}