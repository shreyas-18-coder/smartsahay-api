package com.smartsahay.model;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.regex.Pattern;

public record SchemeInput(
        String slug, String name, String category, String level, String state,
        String description, String applicationMode, String whereToApply,
        String officialLink, String lastDate, String contactInfo, String lastVerified,
        List<String> benefits, List<String> eligibility, List<String> documents, List<String> steps,
        RuleInput rules) {

    private static final Pattern SLUG = Pattern.compile("^[a-z0-9]+(-[a-z0-9]+)*$");
    private static final Set<String> LEVELS = Set.of("Central", "State");
    private static final Set<String> MODES = Set.of("Online", "Offline", "Both");
    private static final Set<String> CATEGORIES = Set.of("GENERAL", "SC", "ST", "OBC", "MINORITY");

    public record RuleInput(Boolean requiresLand, Double minLandHectares, Double maxLandHectares,
                            Integer maxAnnualIncome, Integer minAge, Integer maxAge,
                            Boolean karnatakaOnly, String allowedCategories, String allowedCrops) {

        public void validate(List<String> p) {
            if (minLandHectares != null && (minLandHectares < 0 || minLandHectares > 1000)) {
                p.add("rules.minLandHectares must be between 0 and 1000");
            }
            if (maxLandHectares != null && (maxLandHectares < 0 || maxLandHectares > 1000)) {
                p.add("rules.maxLandHectares must be between 0 and 1000");
            }
            if (minLandHectares != null && maxLandHectares != null && minLandHectares > maxLandHectares) {
                p.add("rules.minLandHectares cannot exceed rules.maxLandHectares");
            }
            if (maxAnnualIncome != null && maxAnnualIncome < 0) {
                p.add("rules.maxAnnualIncome cannot be negative");
            }
            if (minAge != null && (minAge < 0 || minAge > 120)) {
                p.add("rules.minAge must be between 0 and 120");
            }
            if (maxAge != null && (maxAge < 0 || maxAge > 120)) {
                p.add("rules.maxAge must be between 0 and 120");
            }
            if (minAge != null && maxAge != null && minAge > maxAge) {
                p.add("rules.minAge cannot exceed rules.maxAge");
            }
            if (allowedCategories != null && !allowedCategories.isBlank()) {
                for (String c : allowedCategories.split(",")) {
                    if (!CATEGORIES.contains(c.trim().toUpperCase())) {
                        p.add("rules.allowedCategories has unknown category '" + c.trim()
                                + "' (use GENERAL, SC, ST, OBC, MINORITY)");
                    }
                }
            }
            if (allowedCrops != null && allowedCrops.length() > 255) {
                p.add("rules.allowedCrops must be at most 255 characters");
            }
        }

        public String normalizedCategories() { return normalizeCsv(allowedCategories); }

        public String normalizedCrops() { return normalizeCsv(allowedCrops); }

        private static String normalizeCsv(String csv) {
            if (csv == null || csv.isBlank()) {
                return null;
            }
            List<String> parts = new ArrayList<>();
            for (String s : csv.split(",")) {
                if (!s.isBlank()) {
                    parts.add(s.trim().toUpperCase());
                }
            }
            return parts.isEmpty() ? null : String.join(",", parts);
        }
    }

    public List<String> validate(boolean requireSlug) {
        List<String> p = new ArrayList<>();
        if (requireSlug && (slug == null || slug.length() > 100 || !SLUG.matcher(slug).matches())) {
            p.add("slug is required: lowercase letters, digits and hyphens only, max 100 characters");
        }
        text(p, "name", name, 200, true);
        text(p, "category", category, 80, true);
        text(p, "state", state, 50, true);
        text(p, "description", description, 5000, true);
        text(p, "whereToApply", whereToApply, 255, false);
        text(p, "officialLink", officialLink, 255, false);
        text(p, "lastDate", lastDate, 150, false);
        text(p, "contactInfo", contactInfo, 150, false);

        if (level == null || !LEVELS.contains(level)) {
            p.add("level must be Central or State");
        }
        if (applicationMode == null || !MODES.contains(applicationMode)) {
            p.add("applicationMode must be Online, Offline or Both");
        }
        if (officialLink != null && !officialLink.isBlank()) {
            String link = officialLink.trim().toLowerCase();
            if (!link.startsWith("http://") && !link.startsWith("https://")) {
                p.add("officialLink must start with http:// or https://");
            }
        }
        if (lastVerified != null && !lastVerified.isBlank()) {
            try {
                LocalDate.parse(lastVerified.trim());
            } catch (DateTimeParseException e) {
                p.add("lastVerified must be a date like 2026-10-13");
            }
        }

        list(p, "benefits", benefits);
        list(p, "eligibility", eligibility);
        list(p, "documents", documents);
        list(p, "steps", steps);

        if (rules != null) {
            rules.validate(p);
        }
        return p;
    }

    private static void text(List<String> p, String field, String value, int max, boolean required) {
        if (value == null || value.isBlank()) {
            if (required) {
                p.add(field + " is required");
            }
            return;
        }
        if (value.trim().length() > max) {
            p.add(field + " must be at most " + max + " characters");
        }
    }

    private static void list(List<String> p, String field, List<String> items) {
        if (items == null || items.isEmpty()) {
            p.add(field + " needs at least one item");
            return;
        }
        if (items.size() > 30) {
            p.add(field + " can have at most 30 items");
            return;
        }
        for (String item : items) {
            if (item == null || item.isBlank()) {
                p.add(field + " must not contain empty items");
                return;
            }
            if (item.trim().length() > 2000) {
                p.add(field + " items must be at most 2000 characters");
                return;
            }
        }
    }
}