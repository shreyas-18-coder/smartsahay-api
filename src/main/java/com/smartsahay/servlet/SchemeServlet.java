package com.smartsahay.servlet;

import com.google.gson.JsonParseException;
import com.smartsahay.dao.SchemeAdminDAO;
import com.smartsahay.dao.SchemeDAO;
import com.smartsahay.model.Scheme;
import com.smartsahay.model.SchemeInput;
import com.smartsahay.util.AuthGuard;
import com.smartsahay.util.JsonUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.List;
import java.util.Map;

@WebServlet("/api/schemes/*")
public class SchemeServlet extends HttpServlet {

    private final SchemeDAO dao = new SchemeDAO();
    private final SchemeAdminDAO adminDao = new SchemeAdminDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String lang = clean(req.getParameter("lang"));
        if (lang != null) {
            lang = lang.toLowerCase();
            if (!lang.equals("en") && !lang.equals("kn") && !lang.equals("hi")) {
                JsonUtil.error(resp, 400, "lang must be one of en, kn, hi");
                return;
            }
            if (lang.equals("en")) {
                lang = null;
            }
        }

        String path = req.getPathInfo();
        try {
            if (path == null || path.equals("/")) {
                List<Scheme> schemes = dao.findAll(
                        clean(req.getParameter("category")),
                        clean(req.getParameter("state")),
                        clean(req.getParameter("level")),
                        lang);
                JsonUtil.send(resp, 200, schemes);
            } else {
                String slug = path.substring(1);
                Scheme scheme = dao.findBySlug(slug, lang);
                if (scheme == null) {
                    JsonUtil.error(resp, 404, "Scheme not found");
                } else {
                    JsonUtil.send(resp, 200, scheme);
                }
            }
        } catch (SQLException e) {
            getServletContext().log("Failed to load schemes", e);
            JsonUtil.error(resp, 500, "Internal server error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!AuthGuard.requireAdmin(req, resp)) {
            return;
        }
        String path = req.getPathInfo();
        if (path != null && !path.equals("/")) {
            JsonUtil.error(resp, 405, "Use POST /api/schemes to create a scheme");
            return;
        }
        SchemeInput input = readInput(req, resp);
        if (input == null) {
            return;
        }
        List<String> problems = input.validate(true);
        if (!problems.isEmpty()) {
            JsonUtil.error(resp, 400, String.join("; ", problems));
            return;
        }

        try {
            adminDao.create(input);
            Scheme created = dao.findBySlug(input.slug(), null);
            resp.setHeader("Location", req.getContextPath() + "/api/schemes/" + input.slug());
            JsonUtil.send(resp, 201, created);
        } catch (SQLIntegrityConstraintViolationException e) {
            JsonUtil.error(resp, 409, "A scheme with this slug already exists");
        } catch (SQLException e) {
            getServletContext().log("Failed to create scheme", e);
            JsonUtil.error(resp, 500, "Internal server error");
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!AuthGuard.requireAdmin(req, resp)) {
            return;
        }
        String path = req.getPathInfo();
        if (path == null || path.equals("/")) {
            JsonUtil.error(resp, 405, "Use PUT /api/schemes/{slug}");
            return;
        }
        String slug = path.substring(1);

        SchemeInput input = readInput(req, resp);
        if (input == null) {
            return;
        }
        List<String> problems = input.validate(false);
        if (input.slug() != null && !input.slug().equals(slug)) {
            problems.add("slug in the body must match the URL (a slug cannot be changed)");
        }
        if (!problems.isEmpty()) {
            JsonUtil.error(resp, 400, String.join("; ", problems));
            return;
        }

        try {
            if (!adminDao.update(slug, input)) {
                JsonUtil.error(resp, 404, "Scheme not found");
                return;
            }
            JsonUtil.send(resp, 200, dao.findBySlug(slug, null));
        } catch (SQLException e) {
            getServletContext().log("Failed to update scheme", e);
            JsonUtil.error(resp, 500, "Internal server error");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!AuthGuard.requireAdmin(req, resp)) {
            return;
        }
        String path = req.getPathInfo();
        if (path == null || path.equals("/")) {
            JsonUtil.error(resp, 405, "Use DELETE /api/schemes/{slug}");
            return;
        }
        String slug = path.substring(1);

        try {
            if (adminDao.deactivate(slug)) {
                JsonUtil.send(resp, 200, Map.of("message", "Scheme deactivated", "slug", slug));
            } else {
                JsonUtil.error(resp, 404, "Scheme not found");
            }
        } catch (SQLException e) {
            getServletContext().log("Failed to deactivate scheme", e);
            JsonUtil.error(resp, 500, "Internal server error");
        }
    }

    private SchemeInput readInput(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            SchemeInput input = JsonUtil.read(req, SchemeInput.class);
            if (input == null) {
                JsonUtil.error(resp, 400, "Request body is empty");
                return null;
            }
            return input;
        } catch (JsonParseException e) {
            JsonUtil.error(resp, 400, "Request body is not valid JSON");
            return null;
        }
    }

    private String clean(String value) {
        return (value == null || value.isBlank()) ? null : value.trim();
    }
}