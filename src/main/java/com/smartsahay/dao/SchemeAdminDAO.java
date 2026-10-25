package com.smartsahay.dao;

import com.smartsahay.model.SchemeInput;
import com.smartsahay.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.List;

public class SchemeAdminDAO {

    private static final String INSERT_SCHEME =
            "INSERT INTO schemes (slug, name, category, level, state, description, application_mode, " +
                    "where_to_apply, official_link, last_date, contact_info, last_verified) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String UPDATE_SCHEME =
            "UPDATE schemes SET name = ?, category = ?, level = ?, state = ?, description = ?, " +
                    "application_mode = ?, where_to_apply = ?, official_link = ?, last_date = ?, " +
                    "contact_info = ?, last_verified = ? WHERE id = ?";

    // fixed names written by us, never taken from user input
    private static final List<String> CHILD_TABLES = List.of(
            "scheme_benefits", "scheme_eligibility", "scheme_documents", "scheme_steps");
    public void create(SchemeInput in) throws SQLException {
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                int id;
                try (PreparedStatement ps = con.prepareStatement(INSERT_SCHEME, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, in.slug());
                    bindCommon(ps, 2, in);
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        keys.next();
                        id = keys.getInt(1);
                    }
                }
                insertChildren(con, id, in);
                insertRules(con, id, in.rules());
                con.commit();


            } catch (SQLException | RuntimeException e) {
                con.rollback();
                throw e;
            }
        }
    }

    /** Returns false if no active scheme has this slug. */
    public boolean update(String slug, SchemeInput in) throws SQLException {
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                Integer id = findActiveId(con, slug);
                if (id == null) {
                    return false;
                }
                try (PreparedStatement ps = con.prepareStatement(UPDATE_SCHEME)) {
                    bindCommon(ps, 1, in);
                    ps.setInt(12, id);
                    ps.executeUpdate();
                }
                for (String table : CHILD_TABLES) {
                    try (PreparedStatement ps = con.prepareStatement("DELETE FROM " + table + " WHERE scheme_id = ?")) {
                        ps.setInt(1, id);
                        ps.executeUpdate();
                    }
                }
                insertChildren(con, id, in);
                if (in.rules() != null) {
                    try (PreparedStatement ps = con.prepareStatement("DELETE FROM scheme_rules WHERE scheme_id = ?")) {
                        ps.setInt(1, id);
                        ps.executeUpdate();
                    }
                    insertRules(con, id, in.rules());
                }
                con.commit();
                return true;
            } catch (SQLException | RuntimeException e) {
                con.rollback();
                throw e;
            }
        }
    }

    /** Soft delete. Returns false if no active scheme has this slug. */
    public boolean deactivate(String slug) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE schemes SET active = FALSE WHERE slug = ? AND active = TRUE")) {
            ps.setString(1, slug);
            return ps.executeUpdate() > 0;
        }
    }

    private Integer findActiveId(Connection con, String slug) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement("SELECT id FROM schemes WHERE slug = ? AND active = TRUE")) {
            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : null;
            }
        }
    }

    private void bindCommon(PreparedStatement ps, int i, SchemeInput in) throws SQLException {
        ps.setString(i++, in.name().trim());
        ps.setString(i++, in.category().trim());
        ps.setString(i++, in.level());
        ps.setString(i++, in.state().trim());
        ps.setString(i++, in.description().trim());
        ps.setString(i++, in.applicationMode());
        ps.setString(i++, clean(in.whereToApply()));
        ps.setString(i++, clean(in.officialLink()));
        ps.setString(i++, clean(in.lastDate()));
        ps.setString(i++, clean(in.contactInfo()));
        ps.setString(i, clean(in.lastVerified()));
    }

    private void insertChildren(Connection con, int id, SchemeInput in) throws SQLException {
        insertOrdered(con, "INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES (?, ?, ?)",
                id, in.benefits());
        insertOrdered(con, "INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES (?, ?, ?)",
                id, in.eligibility());
        insertOrdered(con, "INSERT INTO scheme_steps (scheme_id, instruction, step_no) VALUES (?, ?, ?)",
                id, in.steps());

        try (PreparedStatement ps = con.prepareStatement(
                "INSERT INTO scheme_documents (scheme_id, document) VALUES (?, ?)")) {
            for (String doc : in.documents()) {
                ps.setInt(1, id);
                ps.setString(2, doc.trim());
                ps.addBatch();
            }
            ps.executeBatch();
        }

    }

    private void insertOrdered(Connection con, String sql, int id, List<String> items) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            int n = 1;
            for (String item : items) {
                ps.setInt(1, id);
                ps.setString(2, item.trim());
                ps.setInt(3, n++);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private void insertRules(Connection con, int id, SchemeInput.RuleInput r) throws SQLException {
        SchemeInput.RuleInput rule = (r != null) ? r
                : new SchemeInput.RuleInput(null, null, null, null, null, null, null, null, null);
        try (PreparedStatement ps = con.prepareStatement(
                "INSERT INTO scheme_rules (scheme_id, requires_land, min_land_hectares, max_land_hectares, " +
                        "max_annual_income, min_age, max_age, karnataka_only, allowed_categories, allowed_crops) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")) {
            ps.setInt(1, id);
            ps.setBoolean(2, Boolean.TRUE.equals(rule.requiresLand()));
            setDouble(ps, 3, rule.minLandHectares());
            setDouble(ps, 4, rule.maxLandHectares());
            setInt(ps, 5, rule.maxAnnualIncome());
            setInt(ps, 6, rule.minAge());
            setInt(ps, 7, rule.maxAge());
            ps.setBoolean(8, Boolean.TRUE.equals(rule.karnatakaOnly()));
            ps.setString(9, rule.normalizedCategories());
            ps.setString(10, rule.normalizedCrops());
            ps.executeUpdate();
        }
    }

    private void setDouble(PreparedStatement ps, int i, Double v) throws SQLException {
        if (v == null) {
            ps.setNull(i, Types.DECIMAL);
        } else {
            ps.setDouble(i, v);
        }
    }

    private void setInt(PreparedStatement ps, int i, Integer v) throws SQLException {
        if (v == null) {
            ps.setNull(i, Types.INTEGER);
        } else {
            ps.setInt(i, v);
        }
    }

    private String clean(String value) {
        return (value == null || value.isBlank()) ? null : value.trim();
    }
}