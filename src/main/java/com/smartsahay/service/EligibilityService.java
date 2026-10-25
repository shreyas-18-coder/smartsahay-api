package com.smartsahay.service;

import com.smartsahay.model.EligibilityRequest;
import com.smartsahay.model.EligibilityResult;
import com.smartsahay.model.Scheme;
import com.smartsahay.model.SchemeRule;

import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class EligibilityService {

    public EligibilityResult check(EligibilityRequest req, List<Scheme> schemes, Map<Integer, SchemeRule> rules) {
        EligibilityResult result = new EligibilityResult();
        for (Scheme scheme : schemes) {
            SchemeRule rule = rules.get(scheme.getId());
            List<String> reasons = (rule == null) ? new ArrayList<>() : evaluate(req, rule);
            if (reasons.isEmpty()) {
                result.addEligible(scheme);
            } else {
                result.addNotEligible(scheme, reasons);
            }
        }
        return result;
    }

    private List<String> evaluate(EligibilityRequest req, SchemeRule r) {
        List<String> reasons = new ArrayList<>();
        double land = req.landInHectares();
        long income = req.getAnnualIncome();
        int age = req.getAge();
        String category = req.normalizedCategory();
        String crop = req.normalizedCrop();

        if (r.isRequiresLand() && land <= 0) {
            reasons.add("Requires owning cultivable land");
        } else if (r.getMinLandHectares() != null && land < r.getMinLandHectares()) {
            reasons.add("Land is below the minimum of " + hectaresText(r.getMinLandHectares()));
        }
        if (r.getMaxLandHectares() != null && land > r.getMaxLandHectares()) {
            reasons.add("Land is above the maximum of " + hectaresText(r.getMaxLandHectares()));
        }
        if (r.getMaxAnnualIncome() != null && income > r.getMaxAnnualIncome()) {
            reasons.add("Annual income is above the limit of \u20B9" + rupees(r.getMaxAnnualIncome()));
        }
        if (r.getMinAge() != null && age < r.getMinAge()) {
            reasons.add("Minimum age is " + r.getMinAge());
        }
        if (r.getMaxAge() != null && age > r.getMaxAge()) {
            reasons.add("Maximum age is " + r.getMaxAge());
        }
        if (r.isKarnatakaOnly() && !"Karnataka".equalsIgnoreCase(req.getState().trim())) {
            reasons.add("Only for farmers in Karnataka");
        }
        if (r.getAllowedCategories() != null && !csvContains(r.getAllowedCategories(), category)) {
            reasons.add("Only for categories: " + pretty(r.getAllowedCategories()));
        }
        if (r.getAllowedCrops() != null) {
            if (crop == null) {
                reasons.add("Requires growing: " + pretty(r.getAllowedCrops()) + " (no crop given)");
            } else if (!csvContains(r.getAllowedCrops(), crop)) {
                reasons.add("Only for crops: " + pretty(r.getAllowedCrops()));
            }
        }
        return reasons;
    }

    private boolean csvContains(String csv, String value) {
        for (String part : csv.split(",")) {
            if (part.trim().equalsIgnoreCase(value)) {
                return true;
            }
        }
        return false;
    }

    private String pretty(String csv) {
        return csv.replace(",", ", ");
    }

    private String hectaresText(double hectares) {
        return String.format(Locale.ENGLISH, "%.2f hectares (about %.1f acres)",
                hectares, hectares / EligibilityRequest.ACRE_TO_HECTARE);
    }

    private String rupees(int amount) {
        return NumberFormat.getInstance(Locale.forLanguageTag("en-IN")).format(amount);
    }
}