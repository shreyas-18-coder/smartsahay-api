package com.smartsahay.dao;

import com.smartsahay.model.Scheme;
import com.smartsahay.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SchemeDAO {

    private static final String COLUMNS =
            "id, slug, name, category, level, state, description, " +
                    "application_mode, where_to_apply, official_link, last_date, contact_info, last_verified";

    public List<Scheme> findAll(String category, String state, String level) throws SQLException {
        return findAll(category, state, level, null);
    }

    public List<Scheme> findAll(String category, String state, String level, String lang) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT " + COLUMNS + " FROM schemes WHERE active = TRUE");
        List<String> params = new ArrayList<>();

        if (category != null) { sql.append(" AND category = ?"); params.add(category); }
        if (state != null)    { sql.append(" AND state = ?");    params.add(state); }
        if (level != null)    { sql.append(" AND level = ?");    params.add(level); }
        sql.append(" ORDER BY id");

        List<Scheme> result = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(sql.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    ps.setString(i + 1, params.get(i));
                }
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        result.add(mapRow(rs));
                    }
                }
            }
            applyTranslations(con, result, lang);
        }
        return result;
    }

    public Scheme findBySlug(String slug) throws SQLException {
        return findBySlug(slug, null);
    }

    public Scheme findBySlug(String slug, String lang) throws SQLException {
        try (Connection con = DBConnection.getConnection()) {
            Scheme scheme = null;
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT " + COLUMNS + " FROM schemes WHERE slug = ? AND active = TRUE")) {
                ps.setString(1, slug);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        scheme = mapRow(rs);
                    }
                }
            }
            if (scheme == null) {
                return null;
            }
            int id = scheme.getId();
            scheme.setBenefits(loadList(con,
                    "SELECT benefit FROM scheme_benefits WHERE scheme_id = ? ORDER BY sort_order", id));
            scheme.setEligibility(loadList(con,
                    "SELECT criteria FROM scheme_eligibility WHERE scheme_id = ? ORDER BY sort_order", id));
            scheme.setDocuments(loadList(con,
                    "SELECT document FROM scheme_documents WHERE scheme_id = ? ORDER BY id", id));
            scheme.setSteps(loadList(con,
                    "SELECT instruction FROM scheme_steps WHERE scheme_id = ? ORDER BY step_no", id));
            applyTranslations(con, List.of(scheme), lang);
            return scheme;
        }
    }

    private void applyTranslations(Connection con, List<Scheme> schemes, String lang) throws SQLException {
        if (lang == null || schemes.isEmpty()) {
            return;
        }
        Map<Integer, String[]> byId = new HashMap<>();
        try (PreparedStatement ps = con.prepareStatement(
                "SELECT scheme_id, name, description FROM scheme_translations WHERE lang = ?")) {
            ps.setString(1, lang);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    byId.put(rs.getInt(1), new String[]{rs.getString(2), rs.getString(3)});
                }
            }
        }
        for (Scheme s : schemes) {
            String[] t = byId.get(s.getId());
            if (t != null) {
                s.setName(t[0]);
                s.setDescription(t[1]);
            }
        }
    }

    private List<String> loadList(Connection con, String sql, int schemeId) throws SQLException {
        List<String> out = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, schemeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.add(rs.getString(1));
                }
            }
        }
        return out;
    }

    private Scheme mapRow(ResultSet rs) throws SQLException {
        Scheme s = new Scheme();
        s.setId(rs.getInt("id"));
        s.setSlug(rs.getString("slug"));
        s.setName(rs.getString("name"));
        s.setCategory(rs.getString("category"));
        s.setLevel(rs.getString("level"));
        s.setState(rs.getString("state"));
        s.setDescription(rs.getString("description"));
        s.setApplicationMode(rs.getString("application_mode"));
        s.setWhereToApply(rs.getString("where_to_apply"));
        s.setOfficialLink(rs.getString("official_link"));
        s.setLastDate(rs.getString("last_date"));
        s.setContactInfo(rs.getString("contact_info"));
        s.setLastVerified(rs.getString("last_verified"));
        return s;
    }
}