package com.smartsahay.model;

public class SchemeRule {
    private int schemeId;
    private boolean requiresLand;
    private Double minLandHectares;
    private Double maxLandHectares;
    private Integer maxAnnualIncome;
    private Integer minAge;
    private Integer maxAge;
    private boolean karnatakaOnly;
    private String allowedCategories;
    private String allowedCrops;

    public int getSchemeId() { return schemeId; }
    public void setSchemeId(int schemeId) { this.schemeId = schemeId; }
    public boolean isRequiresLand() { return requiresLand; }
    public void setRequiresLand(boolean requiresLand) { this.requiresLand = requiresLand; }
    public Double getMinLandHectares() { return minLandHectares; }
    public void setMinLandHectares(Double v) { this.minLandHectares = v; }
    public Double getMaxLandHectares() { return maxLandHectares; }
    public void setMaxLandHectares(Double v) { this.maxLandHectares = v; }
    public Integer getMaxAnnualIncome() { return maxAnnualIncome; }
    public void setMaxAnnualIncome(Integer v) { this.maxAnnualIncome = v; }
    public Integer getMinAge() { return minAge; }
    public void setMinAge(Integer v) { this.minAge = v; }
    public Integer getMaxAge() { return maxAge; }
    public void setMaxAge(Integer v) { this.maxAge = v; }
    public boolean isKarnatakaOnly() { return karnatakaOnly; }
    public void setKarnatakaOnly(boolean v) { this.karnatakaOnly = v; }
    public String getAllowedCategories() { return allowedCategories; }
    public void setAllowedCategories(String v) { this.allowedCategories = v; }
    public String getAllowedCrops() { return allowedCrops; }
    public void setAllowedCrops(String v) { this.allowedCrops = v; }
}