package com.smartsahay.model;

import java.util.ArrayList;
import java.util.List;

public class EligibilityResult {

    private int eligibleCount;
    private int notEligibleCount;
    private List<Scheme> eligible = new ArrayList<>();
    private List<NotEligible> notEligible = new ArrayList<>();
    private String disclaimer = "Results are indicative only, not an official eligibility decision. "
            + "Please confirm with the official scheme portal or your local agriculture office.";

    public void addEligible(Scheme scheme) {
        eligible.add(scheme);
        eligibleCount = eligible.size();
    }

    public void addNotEligible(Scheme scheme, List<String> reasons) {
        notEligible.add(new NotEligible(scheme, reasons));
        notEligibleCount = notEligible.size();
    }

    public static class NotEligible {
        private final Scheme scheme;
        private final List<String> reasons;

        public NotEligible(Scheme scheme, List<String> reasons) {
            this.scheme = scheme;
            this.reasons = reasons;
        }
    }
}