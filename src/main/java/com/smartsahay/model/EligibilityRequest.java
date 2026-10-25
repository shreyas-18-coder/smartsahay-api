package com.smartsahay.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class EligibilityRequest {

    public static final double ACRE_TO_HECTARE = 0.4047;
    private static final Set<String> CATEGORIES = Set.of("GENERAL", "SC", "ST", "OBC", "MINORITY");

    private Double landHectares;
    private Double landAcres;
    private Long annualIncome;
    private Integer age;
    private String state;
    private String category;
    private String crop;

    public Long getAnnualIncome() { return annualIncome; }
    public Integer getAge() { return age; }
    public String getState() { return state; }

    public double landInHectares() {
        return landHectares != null ? landHectares : landAcres * ACRE_TO_HECTARE;
    }

    public String normalizedCategory() { return category.trim().toUpperCase(); }

    public String normalizedCrop() {
        return (crop == null || crop.isBlank()) ? null : crop.trim().toUpperCase();
    }

    public List<String> validate() {
        List<String> problems = new ArrayList<>();
        if (landHectares == null && landAcres == null) {
            problems.add("landHectares (or landAcres) is required");
        } else if (landInHectares() < 0) {
            problems.add("land cannot be negative");
        }
        if (annualIncome == null) {
            problems.add("annualIncome is required");
        } else if (annualIncome < 0) {
            problems.add("annualIncome cannot be negative");
        }
        if (age == null) {
            problems.add("age is required");
        } else if (age < 1 || age > 120) {
            problems.add("age must be between 1 and 120");
        }
        if (state == null || state.isBlank()) {
            problems.add("state is required");
        }
        if (category == null || !CATEGORIES.contains(category.trim().toUpperCase())) {
            problems.add("category must be one of GENERAL, SC, ST, OBC, MINORITY");
        }
        return problems;
    }
}