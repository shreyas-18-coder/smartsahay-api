package com.smartsahay.servlet;

import com.google.gson.JsonParseException;
import com.smartsahay.dao.RuleDAO;
import com.smartsahay.dao.SchemeDAO;
import com.smartsahay.model.EligibilityRequest;
import com.smartsahay.model.Scheme;
import com.smartsahay.model.SchemeRule;
import com.smartsahay.service.EligibilityService;
import com.smartsahay.util.JsonUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/api/eligibility")
public class EligibilityServlet extends HttpServlet {

    private final SchemeDAO schemeDao = new SchemeDAO();
    private final RuleDAO ruleDao = new RuleDAO();
    private final EligibilityService service = new EligibilityService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        EligibilityRequest request;
        try {
            request = JsonUtil.read(req, EligibilityRequest.class);
        } catch (JsonParseException e) {
            JsonUtil.error(resp, 400, "Request body is not valid JSON");
            return;
        }
        if (request == null) {
            JsonUtil.error(resp, 400, "Request body is empty");
            return;
        }
        List<String> problems = request.validate();
        if (!problems.isEmpty()) {
            JsonUtil.error(resp, 400, String.join("; ", problems));
            return;
        }

        try {
            List<Scheme> schemes = schemeDao.findAll(null, null, null);
            Map<Integer, SchemeRule> rules = ruleDao.findAll();
            JsonUtil.send(resp, 200, service.check(request, schemes, rules));
        } catch (SQLException e) {
            getServletContext().log("Eligibility check failed", e);
            JsonUtil.error(resp, 500, "Internal server error");
        }
    }
}