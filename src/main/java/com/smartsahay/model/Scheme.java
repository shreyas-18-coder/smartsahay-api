package com.smartsahay.model;

import java.util.List;

public class Scheme {
    private int id;
    private String slug;
    private String name;
    private String category;
    private String level;
    private String state;
    private String description;
    private String applicationMode;
    private String whereToApply;
    private String officialLink;
    private String lastDate;
    private String contactInfo;
    private String lastVerified;

    // filled only by the detail endpoint
    private List<String> benefits;
    private List<String> eligibility;
    private List<String> documents;
    private List<String> steps;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getApplicationMode() { return applicationMode; }
    public void setApplicationMode(String applicationMode) { this.applicationMode = applicationMode; }
    public String getWhereToApply() { return whereToApply; }
    public void setWhereToApply(String whereToApply) { this.whereToApply = whereToApply; }
    public String getOfficialLink() { return officialLink; }
    public void setOfficialLink(String officialLink) { this.officialLink = officialLink; }
    public String getLastDate() { return lastDate; }
    public void setLastDate(String lastDate) { this.lastDate = lastDate; }
    public String getContactInfo() { return contactInfo; }
    public void setContactInfo(String contactInfo) { this.contactInfo = contactInfo; }
    public List<String> getBenefits() { return benefits; }
    public void setBenefits(List<String> benefits) { this.benefits = benefits; }
    public List<String> getEligibility() { return eligibility; }
    public void setEligibility(List<String> eligibility) { this.eligibility = eligibility; }
    public List<String> getDocuments() { return documents; }
    public void setDocuments(List<String> documents) { this.documents = documents; }
    public List<String> getSteps() { return steps; }
    public void setSteps(List<String> steps) { this.steps = steps; }
    public String getLastVerified() { return lastVerified; }
    public void setLastVerified(String lastVerified) { this.lastVerified = lastVerified; }
}