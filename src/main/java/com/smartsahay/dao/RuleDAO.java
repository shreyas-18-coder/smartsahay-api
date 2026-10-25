package com.smartsahay.dao;

import com.smartsahay.model.SchemeRule;
import com.smartsahay.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class RuleDAO {

    public Map<Integer, SchemeRule> findAll() throws SQLException {
        String sql = "SELECT scheme_id, requires_land, min_land_hectares, max_land_hectares, " +
                "max_annual_income, min_age, max_age, karnataka_only, allowed_categories, allowed_crops " +
                "FROM scheme_rules";
        Map<Integer, SchemeRule> rules = new HashMap<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SchemeRule r = new SchemeRule();
                r.setSchemeId(rs.getInt("scheme_id"));
                r.setRequiresLand(rs.getBoolean("requires_land"));
                r.setMinLandHectares(toDouble(rs.getBigDecimal("min_land_hectares")));
                r.setMaxLandHectares(toDouble(rs.getBigDecimal("max_land_hectares")));
                r.setMaxAnnualIncome(rs.getObject("max_annual_income", Integer.class));
                r.setMinAge(rs.getObject("min_age", Integer.class));
                r.setMaxAge(rs.getObject("max_age", Integer.class));
                r.setKarnatakaOnly(rs.getBoolean("karnataka_only"));
                r.setAllowedCategories(rs.getString("allowed_categories"));
                r.setAllowedCrops(rs.getString("allowed_crops"));
                rules.put(r.getSchemeId(), r);
            }
        }
        return rules;
    }

    private Double toDouble(BigDecimal value) {
        return value == null ? null : value.doubleValue();
    }
}