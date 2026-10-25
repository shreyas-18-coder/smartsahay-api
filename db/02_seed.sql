-- SmartSahay seed data: 17 schemes from Agricultural_Schemes_Details.pdf
-- Run AFTER the CREATE TABLE script. Safe to re-run (clears old data first).
USE smartsahay;
SET NAMES utf8mb4;

DELETE FROM schemes WHERE id > 0;   -- cascades to all child tables
ALTER TABLE schemes AUTO_INCREMENT = 1;

-- =====================================================================
-- 1. PM-KISAN
-- =====================================================================
INSERT INTO schemes (slug, name, category, level, state, description, application_mode, where_to_apply, official_link, last_date, contact_info) VALUES
('pm-kisan-income-support-scheme', 'PM-KISAN Income Support Scheme', 'Financial Assistance', 'Central', 'All India',
 'A central government initiative providing direct income support to landholding farmer families to help them buy agricultural inputs and meet domestic needs.',
 'Both', 'PM-KISAN Portal or Common Service Centres (CSCs)', 'https://pmkisan.gov.in/', 'Open throughout the year', '155261 / 011-24300606');
SET @s = LAST_INSERT_ID();
INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES
(@s, 'Farmers receive ₹6,000 annually.', 1),
(@s, 'Payments are directly processed online into Aadhaar-enabled bank accounts, ensuring transparency with zero middlemen.', 2),
(@s, 'The money is 100% financial assistance from the Central Government and is not a loan.', 3);
INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES
(@s, 'Must own cultivable agricultural land registered in their name in state or revenue records.', 1),
(@s, 'Benefit is limited to one payout per farmer family (husband, wife, and minor children).', 2),
(@s, 'Must be an active Indian citizen residing in India (NRIs excluded).', 3),
(@s, 'Must have a valid Aadhaar card, a bank account linked to Aadhaar (NPCI seeded), and completed e-KYC verification.', 4),
(@s, 'A unique Farmer ID (Kisan Pehchaan Patra) is mandatory for new registrations across 14 states.', 5);
INSERT INTO scheme_documents (scheme_id, document) VALUES
(@s, 'Aadhaar Card'), (@s, 'Land ownership documents (RoR/Pahani)'), (@s, 'Bank account details (Aadhaar seeded)');
INSERT INTO scheme_steps (scheme_id, step_no, instruction) VALUES
(@s, 1, 'Visit the official PM-KISAN portal or download the PM-KISAN mobile app.'),
(@s, 2, 'Click on New Farmer Registration.'),
(@s, 3, 'Fill in the required personal and land details and upload documents.'),
(@s, 4, 'Submit the application for verification by state nodal officers.');
INSERT INTO scheme_rules (scheme_id, requires_land) VALUES (@s, TRUE);

-- =====================================================================
-- 2. PMFBY
-- =====================================================================
INSERT INTO schemes (slug, name, category, level, state, description, application_mode, where_to_apply, official_link, last_date, contact_info) VALUES
('pradhan-mantri-fasal-bima-yojana', 'Pradhan Mantri Fasal Bima Yojana (PMFBY)', 'Crop Insurance', 'Central', 'All India',
 'A highly inclusive crop insurance scheme offering comprehensive financial protection to farmers against crop loss due to non-preventable natural risks.',
 'Online', 'PMFBY Portal, Banks, or CSCs', 'https://pmfby.gov.in/', 'Seasonal deadlines (usually July for Kharif, December for Rabi)', '14447');
SET @s = LAST_INSERT_ID();
INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES
(@s, 'Low premiums: 2.0% for Kharif crops, 1.5% for Rabi crops, and 5.0% for Commercial/Horticultural crops.', 1),
(@s, 'Covers prevented sowing/planting due to adverse weather.', 2),
(@s, 'Covers standing crop damage from drought, floods, pests, diseases, natural fires, and cyclones.', 3),
(@s, 'Covers post-harvest losses for up to 14 days and localized calamities.', 4),
(@s, 'Fast claim payouts using remote sensing, drones, and direct benefit transfers.', 5);
INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES
(@s, 'Open to all loanee and non-loanee farmers.', 1),
(@s, 'Covers owner-cultivators and tenant farmers (sharecroppers) growing notified crops.', 2),
(@s, 'Enrollment is 100% voluntary.', 3);
INSERT INTO scheme_documents (scheme_id, document) VALUES
(@s, 'Aadhaar Card'), (@s, 'Bank passbook'), (@s, 'Land records (RTC/Pahani)'), (@s, 'Crop sowing certificate');
INSERT INTO scheme_steps (scheme_id, step_no, instruction) VALUES
(@s, 1, 'Register on the official PMFBY portal or approach a nearby bank/CSC.'),
(@s, 2, 'Enter land and crop sowing details.'),
(@s, 3, 'Pay the subsidized premium amount.'),
(@s, 4, 'Collect the insurance policy receipt.');
INSERT INTO scheme_rules (scheme_id) VALUES (@s);

-- =====================================================================
-- 3. Kisan Credit Card
-- =====================================================================
INSERT INTO schemes (slug, name, category, level, state, description, application_mode, where_to_apply, official_link, last_date, contact_info) VALUES
('kisan-credit-card-scheme', 'Kisan Credit Card (KCC) Scheme', 'Agricultural Credit', 'Central', 'All India',
 'A credit scheme replacing informal moneylenders with institutional banking to provide timely, hassle-free credit for agricultural operations and allied activities.',
 'Offline', 'Commercial Banks, Cooperative Banks, Regional Rural Banks', 'https://pmkisan.gov.in/', 'Open throughout the year', 'Nearest bank branch helpline');
SET @s = LAST_INSERT_ID();
INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES
(@s, 'Concessional interest rate of 4% per annum for prompt repayers (base rate 7% with 3% PRI).', 1),
(@s, 'Collateral-free loans up to ₹1.60 lakh.', 2),
(@s, 'Flexi limit of ₹10,000 to ₹50,000 for marginal farmers.', 3),
(@s, 'Covers crop cultivation, post-harvest, household consumption, and asset maintenance.', 4),
(@s, 'ATM-enabled RuPay Debit Card provided.', 5),
(@s, 'In-built crop insurance linkage and optional Personal Accident Insurance.', 6);
INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES
(@s, 'Individual or joint owner-cultivators.', 1),
(@s, 'Tenant farmers, sharecroppers, and oral lessees.', 2),
(@s, 'Self-Help Groups (SHGs) and Joint Liability Groups (JLGs).', 3),
(@s, 'Farmers in allied sectors (Animal Husbandry, Dairy, Fisheries).', 4),
(@s, 'Age must be between 18 and 75 years (senior citizens require a co-borrower).', 5);
INSERT INTO scheme_documents (scheme_id, document) VALUES
(@s, 'Aadhaar Card'), (@s, 'PAN Card or Voter ID'), (@s, 'Land documents'), (@s, 'Passport size photographs');
INSERT INTO scheme_steps (scheme_id, step_no, instruction) VALUES
(@s, 1, 'Download the KCC application form from the PM-Kisan portal.'),
(@s, 2, 'Fill out the form and attach the required KYC and land documents.'),
(@s, 3, 'Submit the application to the nearest bank branch.'),
(@s, 4, 'Bank issues the card and sets the limit post field verification.');
INSERT INTO scheme_rules (scheme_id, min_age, max_age) VALUES (@s, 18, 75);

-- =====================================================================
-- 4. PMKSY
-- =====================================================================
INSERT INTO schemes (slug, name, category, level, state, description, application_mode, where_to_apply, official_link, last_date, contact_info) VALUES
('pm-krishi-sinchai-yojana', 'PM Krishi Sinchai Yojana (PMKSY)', 'Irrigation Subsidy', 'Central', 'All India',
 'An irrigation initiative focused on "Per Drop More Crop" by promoting micro-irrigation systems to reduce water waste and enhance agricultural productivity.',
 'Both', 'State Agriculture/Horticulture Department portals', 'https://pmksy.gov.in/', 'Subject to state notifications', 'State Agriculture Department Helpdesk');
SET @s = LAST_INSERT_ID();
INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES
(@s, 'Small and marginal farmers get up to a 55% subsidy on micro-irrigation system installations.', 1),
(@s, 'Other farmers receive up to a 45% subsidy.', 2),
(@s, 'Subsidy is credited securely via Direct Benefit Transfer (DBT).', 3),
(@s, 'Assistance for water harvesting and distribution.', 4);
INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES
(@s, 'Applicant must be a citizen of India and at least 18 years old.', 1),
(@s, 'Must possess valid cultivable land records in their name.', 2),
(@s, 'Members of SHGs, cooperative societies, and tenant farmers with a valid lease (minimum 7 years) are eligible.', 3),
(@s, 'Financial assistance capped at a maximum ceiling of 5 hectares per beneficiary.', 4),
(@s, 'Only one member per agricultural family can avail of the primary hardware subsidy.', 5);
INSERT INTO scheme_documents (scheme_id, document) VALUES
(@s, 'Aadhaar Card'), (@s, 'Land ownership documents'), (@s, 'Bank passbook details'),
(@s, 'Quotation for the micro-irrigation system from an empanelled vendor');
INSERT INTO scheme_steps (scheme_id, step_no, instruction) VALUES
(@s, 1, 'Apply through the respective state agriculture or horticulture department portal.'),
(@s, 2, 'Submit the required documents and vendor quotation.'),
(@s, 3, 'Officials conduct field verification.'),
(@s, 4, 'Install the system and receive the DBT subsidy.');
INSERT INTO scheme_rules (scheme_id, max_land_hectares, min_age) VALUES (@s, 5.00, 18);

-- =====================================================================
-- 5. Soil Health Card
-- =====================================================================
INSERT INTO schemes (slug, name, category, level, state, description, application_mode, where_to_apply, official_link, last_date, contact_info) VALUES
('soil-health-card-scheme', 'Soil Health Card Scheme', 'Agricultural Extension', 'Central', 'All India',
 'A scheme designed to help farmers shift to scientific farming by testing soil quality and providing tailored fertilizer recommendations.',
 'Offline', 'Local Agriculture Office / Village Panchayat', 'https://soilhealth.dac.gov.in/', 'Continuous multi-year cycle', 'Local Agriculture Extension Officer');
SET @s = LAST_INSERT_ID();
INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES
(@s, 'Provides customized fertilizer recommendations, preventing chemical overuse.', 1),
(@s, 'Offers tailored dosage recommendations for up to six different crops.', 2),
(@s, 'Significantly lowers overall cultivation costs by eliminating unnecessary fertilizer purchases.', 3),
(@s, 'Suggests corrective steps for acidic or alkaline soil.', 4),
(@s, 'Boosts crop yield and ensures long-term land health.', 5);
INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES
(@s, 'Every farmer in India is eligible.', 1),
(@s, 'No landholding size limits.', 2),
(@s, 'Covers all agricultural land, including irrigated and rainfed areas.', 3);
INSERT INTO scheme_documents (scheme_id, document) VALUES (@s, 'Aadhaar Card'), (@s, 'Land details/Survey number');
INSERT INTO scheme_steps (scheme_id, step_no, instruction) VALUES
(@s, 1, 'Agriculture department officials collect soil samples from village clusters.'),
(@s, 2, 'Samples are sent to soil testing laboratories.'),
(@s, 3, 'Soil Health Cards are printed and distributed to the farmers.');
INSERT INTO scheme_rules (scheme_id) VALUES (@s);

-- =====================================================================
-- 6. NMSA
-- =====================================================================
INSERT INTO schemes (slug, name, category, level, state, description, application_mode, where_to_apply, official_link, last_date, contact_info) VALUES
('national-mission-on-sustainable-agriculture', 'National Mission on Sustainable Agriculture (NMSA)', 'Sustainable Farming', 'Central', 'All India',
 'Promotes sustainable agriculture focusing on integrated farming, resource optimization, and climate-resilient practices, especially in rainfed areas.',
 'Offline', 'District Agriculture Office', 'https://nmsa.dac.gov.in/', 'Subject to state-wise implementation', 'District Agriculture Officer');
SET @s = LAST_INSERT_ID();
INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES
(@s, 'Integrated Farming System (IFS) subsidy up to ₹30,000 per family.', 1),
(@s, 'Capital subsidies to build common farm utilities (fodder/grain banks).', 2),
(@s, 'Support for setting up secondary income streams like fisheries, dairy, and apiculture.', 3),
(@s, 'Micro-irrigation technical setup support under "Per Drop More Crop".', 4),
(@s, 'Tree planting subsidies under Agroforestry to boost timber/fruit revenue.', 5);
INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES
(@s, 'All farmers eligible; priority to women, SC, and ST farmers.', 1),
(@s, 'Focuses on arid, semi-arid, and sub-humid areas (less than 60% irrigated land).', 2),
(@s, 'Must possess valid land documents and an Aadhaar card.', 3),
(@s, 'A valid Soil Health Card is generally required.', 4);
INSERT INTO scheme_documents (scheme_id, document) VALUES
(@s, 'Aadhaar Card'), (@s, 'Land ownership proof'), (@s, 'Soil Health Card'), (@s, 'Bank account details');
INSERT INTO scheme_steps (scheme_id, step_no, instruction) VALUES
(@s, 1, 'Approach the District Agriculture Office.'),
(@s, 2, 'Submit a proposal for integrated farming or agroforestry adoption.'),
(@s, 3, 'Approval and funding are managed at the district/state level based on clusters.');
INSERT INTO scheme_rules (scheme_id, requires_land) VALUES (@s, TRUE);

-- =====================================================================
-- 7. Agriculture Mechanization Subsidy
-- =====================================================================
INSERT INTO schemes (slug, name, category, level, state, description, application_mode, where_to_apply, official_link, last_date, contact_info) VALUES
('agriculture-mechanization-subsidy', 'Agriculture Mechanization Subsidy Schemes', 'Equipment Subsidy', 'Central', 'All India',
 'Provides financial subsidies to farmers and farmer groups for purchasing modern agricultural machinery to increase farm productivity and reduce manual labor.',
 'Online', 'agrimachinery.nic.in (or state equivalent portal)', 'https://agrimachinery.nic.in/', 'Open based on budget availability', 'State Agriculture Engineering Department');
SET @s = LAST_INSERT_ID();
INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES
(@s, '40% to 50% subsidy for general farmers on machinery like tractors and tillers.', 1),
(@s, '50% to 80% subsidy for women, SC, ST, and small/marginal farmers.', 2),
(@s, '40% to 100% grant for groups to establish Custom Hiring Centers (CHCs).', 3),
(@s, 'Direct Benefit Transfer (DBT) of the subsidy amount.', 4),
(@s, 'Supports special farming tools like solar sprayers and agricultural drones.', 5);
INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES
(@s, 'Must own cultivable agricultural land with valid records.', 1),
(@s, 'Priority given to small, marginal, women, SC, and ST farmers.', 2),
(@s, 'A 7 to 10-year cooling-off period applies before subsidizing the same category machine again.', 3),
(@s, 'SHGs, cooperative societies, and FPOs are eligible for CHC grants.', 4);
INSERT INTO scheme_documents (scheme_id, document) VALUES
(@s, 'Aadhaar Card'), (@s, 'Land records (7/12 extract or RoR)'), (@s, 'Bank passbook'),
(@s, 'Quotation of the machinery from a certified dealer');
INSERT INTO scheme_steps (scheme_id, step_no, instruction) VALUES
(@s, 1, 'Register on the direct benefit transfer portal for agricultural mechanization.'),
(@s, 2, 'Select the required machinery and verified manufacturer/dealer.'),
(@s, 3, 'Upload documents and submit the application.'),
(@s, 4, 'Once approved, purchase the equipment and receive the subsidy via DBT.');
INSERT INTO scheme_rules (scheme_id, requires_land) VALUES (@s, TRUE);

-- =====================================================================
-- 8. PM-KUSUM
-- =====================================================================
INSERT INTO schemes (slug, name, category, level, state, description, application_mode, where_to_apply, official_link, last_date, contact_info) VALUES
('pm-kusum-scheme', 'PM-KUSUM Scheme', 'Renewable Energy', 'Central', 'All India',
 'Promotes solar energy usage in agriculture by providing subsidies for setting up solar power plants and solar-powered irrigation pumps.',
 'Online', 'State Nodal Agencies for Renewable Energy', 'https://pmkusum.mnre.gov.in/', 'Open throughout the year', '1800-180-3333');
SET @s = LAST_INSERT_ID();
INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES
(@s, 'Sell surplus solar power back to the grid for a steady revenue stream for 25 years.', 1),
(@s, 'Lease barren land to solar developers for annual rent.', 2),
(@s, 'Up to 60% government subsidy on solar pumps (up to 7.5 HP).', 3),
(@s, 'Ensures reliable daytime irrigation and grid independence.', 4),
(@s, 'Zero fuel costs and reduced carbon emissions.', 5);
INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES
(@s, 'Individual farmers, FPOs, Cooperatives, Panchayats, and Water User Associations are eligible.', 1),
(@s, 'For solar plants, land can be barren, fallow, agricultural, pasturage, or marshy.', 2),
(@s, 'For solar pumps, applicants must own cultivable land with a valid water source/boring permission.', 3),
(@s, 'Subsidies capped at 7.5 HP capacity for pumps.', 4);
INSERT INTO scheme_documents (scheme_id, document) VALUES
(@s, 'Aadhaar Card'), (@s, 'Land ownership documents'), (@s, 'Proof of water source permission'), (@s, 'Bank account details');
INSERT INTO scheme_steps (scheme_id, step_no, instruction) VALUES
(@s, 1, 'Visit the state renewable energy portal.'),
(@s, 2, 'Select the relevant PM-KUSUM component (Solar Pump or Power Plant).'),
(@s, 3, 'Submit land and KYC details.'),
(@s, 4, 'Pay the beneficiary share; installation is executed by empanelled vendors.');
INSERT INTO scheme_rules (scheme_id) VALUES (@s);

-- =====================================================================
-- 9. Krishi Bhagya (Karnataka)
-- =====================================================================
INSERT INTO schemes (slug, name, category, level, state, description, application_mode, where_to_apply, official_link, last_date, contact_info) VALUES
('krishi-bhagya-scheme', 'Krishi Bhagya Scheme', 'Irrigation and Infrastructure', 'State', 'Karnataka',
 'A state scheme aimed at improving agricultural productivity in dryland and rain-fed areas through rainwater harvesting and micro-irrigation.',
 'Both', 'Raitha Samparka Kendra (RSK)', 'https://raitamitra.karnataka.gov.in/', 'Subject to state notification', 'Local Raitha Samparka Kendra');
SET @s = LAST_INSERT_ID();
INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES
(@s, '80% (General) to 90% (SC/ST) subsidy for digging farm ponds (Krishi Honda).', 1),
(@s, '80% to 90% subsidy for pond linings and covers to prevent evaporation.', 2),
(@s, 'Up to 50% subsidy on water lifting pumps.', 3),
(@s, 'Financial aid for drip or sprinkler irrigation units.', 4),
(@s, 'Up to 50% subsidy for constructing polyhouses/shadenet houses.', 5);
INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES
(@s, 'Permanent resident and farmer in Karnataka.', 1),
(@s, 'Land must fall under rain-fed (dryland) or drought-prone regions.', 2),
(@s, 'Must own between 1 acre and 5 hectares of land.', 3),
(@s, 'Must have a valid FID on the Karnataka FRUITS portal.', 4),
(@s, 'Should not have received benefits under this scheme in the last 5 years.', 5);
INSERT INTO scheme_documents (scheme_id, document) VALUES
(@s, 'Aadhaar Card'), (@s, 'FRUITS ID'), (@s, 'Land records (RTC)'), (@s, 'Bank passbook');
INSERT INTO scheme_steps (scheme_id, step_no, instruction) VALUES
(@s, 1, 'Ensure registration on the FRUITS portal.'),
(@s, 2, 'Submit an application via the Raitha Mitra portal or offline at the RSK.'),
(@s, 3, 'Attach required quotations and land details.'),
(@s, 4, 'Subject to field inspection and budget allocation.');
-- 1 acre = 0.4047 ha, rounded up to 0.41
INSERT INTO scheme_rules (scheme_id, requires_land, min_land_hectares, max_land_hectares, karnataka_only) VALUES (@s, TRUE, 0.41, 5.00, TRUE);

-- =====================================================================
-- 10. Raitha Vidya Nidhi Scholarship (Karnataka)
-- =====================================================================
INSERT INTO schemes (slug, name, category, level, state, description, application_mode, where_to_apply, official_link, last_date, contact_info) VALUES
('raitha-vidya-nidhi-scholarship', 'Raitha Vidya Nidhi Scholarship', 'Education', 'State', 'Karnataka',
 'A scholarship program providing financial assistance to the children of registered farmers and agricultural labourers to pursue higher education.',
 'Online', 'State Scholarship Portal (SSP) Karnataka', 'https://ssp.postmatric.karnataka.gov.in/', 'Usually coincides with academic year start (October/November)', '1902');
SET @s = LAST_INSERT_ID();
INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES
(@s, 'Financial aid ranging from ₹2,000 to ₹11,000 per year.', 1),
(@s, 'Funds are directly transferred via Direct Benefit Transfer (DBT) into the student''s bank account.', 2);
INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES
(@s, 'Must be the child of a registered farmer or agricultural labourer in Karnataka.', 1),
(@s, 'Parent must possess a valid FRUITS ID.', 2),
(@s, 'Family agricultural land holding must be under 5 hectares.', 3),
(@s, 'Total annual family income must not exceed ₹8 Lakh.', 4),
(@s, 'Student must be enrolled in a recognized institution in Karnataka and must have cleared the previous academic year.', 5);
INSERT INTO scheme_documents (scheme_id, document) VALUES
(@s, 'Aadhaar Card (Student and Parent)'), (@s, 'Parent''s FRUITS ID'), (@s, 'Income Certificate'),
(@s, 'Previous year marks card'), (@s, 'Aadhaar-seeded bank account details');
INSERT INTO scheme_steps (scheme_id, step_no, instruction) VALUES
(@s, 1, 'Visit the State Scholarship Portal (SSP).'),
(@s, 2, 'Create an account or log in.'),
(@s, 3, 'Enter the student''s details and the parent''s FRUITS ID.'),
(@s, 4, 'Upload documents and submit.');
INSERT INTO scheme_rules (scheme_id, max_land_hectares, max_annual_income, karnataka_only) VALUES (@s, 5.00, 800000, TRUE);

-- =====================================================================
-- 11. Siri Dhanya (Millet) Promotion (Karnataka)
-- =====================================================================
INSERT INTO schemes (slug, name, category, level, state, description, application_mode, where_to_apply, official_link, last_date, contact_info) VALUES
('siri-dhanya-promotion', 'Siri Dhanya (Millet) Promotion', 'Crop Promotion', 'State', 'Karnataka',
 'Promotes the cultivation and consumption of minor millets (Siridhanya) through direct financial incentives, recognizing their health and ecological benefits.',
 'Online', 'Raitha Samparka Kendra / Online Portal', 'https://raitamitra.karnataka.gov.in/', 'Seasonal (per crop cycle)', 'Local Agriculture Officer');
SET @s = LAST_INSERT_ID();
INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES
(@s, 'Farmers receive a direct incentive of ₹10,000 per hectare (Raitha Siri scheme).', 1),
(@s, 'Access to 50% seed subsidies, training workshops, and machinery grants for processing.', 2),
(@s, 'Funds are disbursed via DBT in two installments post GPS verification.', 3),
(@s, 'Promotes grains that aid in managing diabetes, digestive health, and gluten allergies.', 4);
INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES
(@s, 'Must be a registered landowner/farmer cultivating any of the 5 core minor millets (Foxtail, Barnyard, Kodo, Little, or Browntop).', 1),
(@s, 'Cash benefit is strictly capped at a maximum of 2 hectares per individual beneficiary.', 2);
INSERT INTO scheme_documents (scheme_id, document) VALUES
(@s, 'Aadhaar Card'), (@s, 'FRUITS ID'), (@s, 'Land records (RTC)'), (@s, 'Bank passbook');
INSERT INTO scheme_steps (scheme_id, step_no, instruction) VALUES
(@s, 1, 'Ensure FRUITS portal registration.'),
(@s, 2, 'Apply through the Raitha Mitra portal for the millet promotion scheme.'),
(@s, 3, 'Officials conduct GPS-based crop photo verification 30 days after sowing.');
INSERT INTO scheme_rules (scheme_id, requires_land, karnataka_only, allowed_crops) VALUES (@s, TRUE, TRUE, 'MILLET');

-- =====================================================================
-- 12. Zero-Percent Interest Agricultural Credit (Karnataka)
-- =====================================================================
INSERT INTO schemes (slug, name, category, level, state, description, application_mode, where_to_apply, official_link, last_date, contact_info) VALUES
('zero-percent-interest-agricultural-credit', 'Zero-Percent Interest Agricultural Credit', 'Agricultural Credit', 'State', 'Karnataka',
 'Provides massive interest subvention to farmers, eliminating interest costs on short-term crop loans to prevent exploitation by private moneylenders.',
 'Offline', 'Primary Agricultural Credit Cooperative Society (PACS)', 'https://sahakarasindhu.karnataka.gov.in/', 'Open throughout the year', 'Local PACS or Cooperative Bank');
SET @s = LAST_INSERT_ID();
INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES
(@s, '0% interest on short-term crop cultivation loans up to ₹3.00 lakh (extended to ₹5.00 lakh in some PACS).', 1),
(@s, '0% interest up to ₹2.00 lakh for working capital in animal husbandry and fisheries.', 2),
(@s, 'Medium and long-term loans up to ₹10.00 - ₹15.00 lakh available at a heavily reduced 3% interest.', 3),
(@s, 'State government pays the entire interest burden to the cooperative bank.', 4);
INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES
(@s, 'Permanent resident citizen of Karnataka.', 1),
(@s, 'Small or marginal farmer holding valid agricultural land.', 2),
(@s, 'Credit must be strictly for agricultural production or allied activities.', 3),
(@s, 'Loan must be availed through authorized cooperative institutions (PACS).', 4),
(@s, 'Existing loan accounts must not be classified as NPA.', 5);
INSERT INTO scheme_documents (scheme_id, document) VALUES
(@s, 'Aadhaar Card'), (@s, 'Land ownership documents'), (@s, 'Bank passbook'), (@s, 'No Objection Certificate (if required)');
INSERT INTO scheme_steps (scheme_id, step_no, instruction) VALUES
(@s, 1, 'Visit the local Primary Agricultural Credit Cooperative Society (PACS) or DCC bank.'),
(@s, 2, 'Fill out the loan application and submit land valuation documents.'),
(@s, 3, 'Loan is sanctioned and disbursed directly to the account.');
-- small/marginal farmer = up to 2 hectares
INSERT INTO scheme_rules (scheme_id, requires_land, max_land_hectares, karnataka_only) VALUES (@s, TRUE, 2.00, TRUE);

-- =====================================================================
-- 13. PKVY
-- =====================================================================
INSERT INTO schemes (slug, name, category, level, state, description, application_mode, where_to_apply, official_link, last_date, contact_info) VALUES
('paramparagat-krishi-vikas-yojana', 'Paramparagat Krishi Vikas Yojana (PKVY)', 'Organic Farming', 'Central', 'All India',
 'Promotes organic farming through a cluster-based approach, providing financial and technical support to farmers transitioning to chemical-free agriculture.',
 'Offline', 'Local Agriculture Department', 'https://pgsindia-ncof.gov.in/', 'Continuous', 'State Agriculture Department');
SET @s = LAST_INSERT_ID();
INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES
(@s, 'Financial assistance for adopting 100% chemical-free cultivation.', 1),
(@s, 'Provides funding for organic certification and brand building.', 2),
(@s, 'Helps establish direct market access for organic produce.', 3);
INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES
(@s, 'Open to any individual farmer or institutional farm willing to adopt chemical-free cultivation.', 1),
(@s, 'Financial incentives capped at a maximum of 2 hectares per farmer.', 2),
(@s, 'Farmers must join or form a localized cluster of at least 50 farmers managing roughly 20 hectares.', 3),
(@s, 'At least 30% of the total budget allocation is reserved for women beneficiaries.', 4);
INSERT INTO scheme_documents (scheme_id, document) VALUES
(@s, 'Aadhaar Card'), (@s, 'Land records'), (@s, 'Cluster membership details');
INSERT INTO scheme_steps (scheme_id, step_no, instruction) VALUES
(@s, 1, 'Group together with local farmers to form a 50-member cluster.'),
(@s, 2, 'Approach the local agriculture extension office with the cluster proposal.'),
(@s, 3, 'Get registered under the Participatory Guarantee System (PGS) for India.');
INSERT INTO scheme_rules (scheme_id) VALUES (@s);

-- =====================================================================
-- 14. NMNF
-- =====================================================================
INSERT INTO schemes (slug, name, category, level, state, description, application_mode, where_to_apply, official_link, last_date, contact_info) VALUES
('national-mission-on-natural-farming', 'National Mission on Natural Farming (NMNF)', 'Natural Farming', 'Central', 'All India',
 'A mission encouraging farmers to transition entirely to natural farming, eliminating synthetic fertilizers, chemical pesticides, and GMO seeds.',
 'Online', 'NMNF Portal', 'https://naturalfarming.dac.gov.in/', 'Open year round', 'District Agriculture Officer');
SET @s = LAST_INSERT_ID();
INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES
(@s, 'Output-based adoption incentive of ₹4,000 per acre per year for up to 2 years (capped at 1 acre).', 1),
(@s, 'Funds on-farm natural preparation and livestock upkeep.', 2),
(@s, 'Technical support, field guidance, and training through Bio-input Resource Centres (BRCs).', 3);
INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES
(@s, 'Willingness to transition away from synthetic chemicals and GMO seeds.', 1),
(@s, 'Priority given to small and marginal farmers (holding up to 2 hectares) and tribal communities.', 2),
(@s, 'Farmers must enroll on the official portal and link their profile to the PM-Kisan database.', 3);
INSERT INTO scheme_documents (scheme_id, document) VALUES
(@s, 'Aadhaar Card'), (@s, 'PM-Kisan ID'), (@s, 'Land details');
INSERT INTO scheme_steps (scheme_id, step_no, instruction) VALUES
(@s, 1, 'Register on the official NMNF portal.'),
(@s, 2, 'Ensure PM-Kisan data linkage.'),
(@s, 3, 'Participate in local BRC training and transition farming practices.');
INSERT INTO scheme_rules (scheme_id) VALUES (@s);

-- =====================================================================
-- 15. Karnataka Raitha Suraksha PMFBY
-- =====================================================================
INSERT INTO schemes (slug, name, category, level, state, description, application_mode, where_to_apply, official_link, last_date, contact_info) VALUES
('karnataka-raitha-suraksha-pmfby', 'Karnataka Raitha Suraksha Pradhana Mantri Fasal Bima Yojana', 'Crop Insurance', 'State', 'Karnataka',
 'Karnataka''s localized implementation of the PMFBY, providing crucial financial protection against crop loss due to drought, floods, pests, and unseasonal rains.',
 'Both', 'Samrakshane Portal, Grama One, or Banks', 'https://samrakshane.karnataka.gov.in/', 'Seasonal (Notified annually by the state)', '1800 180 1551 (Toll Free)');
SET @s = LAST_INSERT_ID();
INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES
(@s, 'Highly subsidized premium rates (2% Kharif, 1.5% Rabi, 5% Commercial).', 1),
(@s, 'Covers prevented sowing, standing crop damage, and localized calamities.', 2),
(@s, 'Post-harvest loss coverage for up to 14 days.', 3),
(@s, 'Income stabilization to prevent structural debt.', 4);
INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES
(@s, 'All categories of farmers (land-owning, tenant, and sharecroppers) cultivating notified crops in Karnataka.', 1),
(@s, 'Must have a clear insurable interest in the cultivated land/crop.', 2),
(@s, 'Enrollment is strictly optional.', 3),
(@s, 'Cannot claim if already received separate compensation for the exact same loss.', 4);
INSERT INTO scheme_documents (scheme_id, document) VALUES
(@s, 'Aadhaar Card'), (@s, 'Bank account passbook (Aadhaar linked)'), (@s, 'Land records (RTC/Pahani)'),
(@s, 'Crop Sowing Certificate (Self-declaration or Dept. issued)');
INSERT INTO scheme_steps (scheme_id, step_no, instruction) VALUES
(@s, 1, 'Register via Grama One, Karnataka One, CSCs, or nationalized banks.'),
(@s, 2, 'Submit land details and crop sowing certificates.'),
(@s, 3, 'Pay the nominal premium to complete the enrollment.');
INSERT INTO scheme_rules (scheme_id, karnataka_only) VALUES (@s, TRUE);

-- =====================================================================
-- 16. Ganga Kalyana (Karnataka)
-- =====================================================================
INSERT INTO schemes (slug, name, category, level, state, description, application_mode, where_to_apply, official_link, last_date, contact_info) VALUES
('ganga-kalyana-scheme', 'Ganga Kalyana Scheme', 'Irrigation', 'State', 'Karnataka',
 'Provides full financial assistance to marginalized farmers to establish end-to-end irrigation facilities, including borewells, pump sets, and electrification.',
 'Online', 'Respective SC/ST/OBC/Minorities Development Corporations', 'https://kmdc.karnataka.gov.in/', 'As notified annually', 'District Corporation Office');
SET @s = LAST_INSERT_ID();
INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES
(@s, '100% funding for drilling individual borewells, installing pumps, and electrification.', 1),
(@s, 'Financial packages up to ₹4.75 Lakhs in high-water-stress districts and ₹3.75 Lakhs in others.', 2),
(@s, 'Open well construction for coastal/hilly terrains.', 3),
(@s, 'Community/lift irrigation projects for farmer groups holding 8+ acres.', 4);
INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES
(@s, 'Must belong to SC, ST, OBC (Cat 1, 2A, 3A, 3B), or Religious Minorities.', 1),
(@s, 'Permanent resident of Karnataka and classified as a small/marginal farmer.', 2),
(@s, 'Own 1.5 to 5 acres of dry land (lowered to 1 acre in hilly/coastal districts).', 3),
(@s, 'Annual household income must not exceed ₹6.00 Lakhs.', 4),
(@s, 'Must be at least 18 years old.', 5);
INSERT INTO scheme_documents (scheme_id, document) VALUES
(@s, 'Aadhaar Card'), (@s, 'Caste Certificate'), (@s, 'Income Certificate'), (@s, 'Land records (RTC)'), (@s, 'Small/Marginal Farmer Certificate');
INSERT INTO scheme_steps (scheme_id, step_no, instruction) VALUES
(@s, 1, 'Visit the respective development corporation portal based on category (e.g., KMDC, KDDC).'),
(@s, 2, 'Fill out the online application and upload certificates.'),
(@s, 3, 'Selections are finalized by the district-level committee.');
-- 1 acre = 0.41 ha (hilly/coastal minimum), 5 acres = 2.02 ha
INSERT INTO scheme_rules (scheme_id, requires_land, min_land_hectares, max_land_hectares, max_annual_income, min_age, karnataka_only, allowed_categories)
VALUES (@s, TRUE, 0.41, 2.02, 600000, 18, TRUE, 'SC,ST,OBC,MINORITY');

-- =====================================================================
-- 17. Krishi Vistara & Siri Dhanya Promotion (Karnataka)
-- =====================================================================
INSERT INTO schemes (slug, name, category, level, state, description, application_mode, where_to_apply, official_link, last_date, contact_info) VALUES
('krishi-vistara-siri-dhanya-promotion', 'Krishi Vistara & Siri Dhanya Promotion', 'Agricultural Infrastructure & Promotion', 'State', 'Karnataka',
 'A combined state budget initiative to promote alternative incomes through post-harvest infrastructure, millet cultivation, and eco-friendly farming practices.',
 'Online', 'Agriculture Department / Raitha Samparka Kendra', 'https://raitamitra.karnataka.gov.in/', 'Ongoing as per state allocations', 'District Agriculture Office');
SET @s = LAST_INSERT_ID();
INSERT INTO scheme_benefits (scheme_id, benefit, sort_order) VALUES
(@s, 'Funding for setting up crop processing, grading, and packaging units.', 1),
(@s, 'Financial backing to recycle agricultural waste into organic resources.', 2),
(@s, '₹10,000 per hectare incentive for minor millet growers under Raitha Siri.', 3),
(@s, 'Subsidies for soil restoration and Alternate Wetting and Drying (AWD) irrigation models.', 4),
(@s, 'Direct market linkages to avoid middlemen.', 5);
INSERT INTO scheme_eligibility (scheme_id, criteria, sort_order) VALUES
(@s, 'Resident farmers actively cultivating land in Karnataka.', 1),
(@s, 'Must possess a valid FRUITS ID.', 2),
(@s, 'Targeted at small/marginal farmers, rural youth, and agri-entrepreneurs.', 3),
(@s, 'Millet incentives require a minimum landholding of 1 acre.', 4),
(@s, 'FPOs and joint liability groups preferred for community infrastructure.', 5);
INSERT INTO scheme_documents (scheme_id, document) VALUES
(@s, 'Aadhaar Card'), (@s, 'FRUITS ID'), (@s, 'Land records (RTC)'), (@s, 'Project proposal/quotation for processing units');
INSERT INTO scheme_steps (scheme_id, step_no, instruction) VALUES
(@s, 1, 'Apply through the Karnataka State Department of Agriculture portal (Raitha Mitra).'),
(@s, 2, 'Submit business proposals for infrastructure or register crops for millet incentives.'),
(@s, 3, 'Subject to field verification and budget availability.');
INSERT INTO scheme_rules (scheme_id, karnataka_only) VALUES (@s, TRUE);

-- =====================================================================
-- Sanity check (should show 17 schemes, 17 rules rows)
-- =====================================================================
SELECT (SELECT COUNT(*) FROM schemes)            AS schemes,
       (SELECT COUNT(*) FROM scheme_rules)       AS rules,
       (SELECT COUNT(*) FROM scheme_benefits)    AS benefits,
       (SELECT COUNT(*) FROM scheme_eligibility) AS eligibility,
       (SELECT COUNT(*) FROM scheme_documents)   AS documents,
       (SELECT COUNT(*) FROM scheme_steps)       AS steps;schemesscheme_benefitsscheme_documentsscheme_eligibility
