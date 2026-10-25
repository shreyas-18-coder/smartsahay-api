CREATE DATABASE IF NOT EXISTS smartsahay
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE smartsahay;

CREATE TABLE schemes (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  slug             VARCHAR(100) NOT NULL UNIQUE,
  name             VARCHAR(200) NOT NULL,
  category         VARCHAR(80)  NOT NULL,
  level            ENUM('Central','State') NOT NULL,
  state            VARCHAR(50)  NOT NULL,          -- 'All India' or 'Karnataka'
  description      TEXT NOT NULL,
  application_mode ENUM('Online','Offline','Both') NOT NULL,
  where_to_apply   VARCHAR(255),
  official_link    VARCHAR(255),
  last_date        VARCHAR(150),
  contact_info     VARCHAR(150),
  INDEX idx_category (category),
  INDEX idx_state (state)
);

CREATE TABLE scheme_benefits (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  scheme_id   INT NOT NULL,
  benefit     TEXT NOT NULL,
  sort_order  INT NOT NULL DEFAULT 0,
  FOREIGN KEY (scheme_id) REFERENCES schemes(id) ON DELETE CASCADE
);

CREATE TABLE scheme_eligibility (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  scheme_id   INT NOT NULL,
  criteria    TEXT NOT NULL,
  sort_order  INT NOT NULL DEFAULT 0,idscheme_idscheme_benefitsscheme_idcriteriasort_orderscheme_idscheme_idscheme_iddocumentnamestatenamecategoryapplication_modeapplication_modecategoryschemesscheme_rulesscheme_steps
  FOREIGN KEY (scheme_id) REFERENCES schemes(id) ON DELETE CASCADE
);

CREATE TABLE scheme_documents (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  scheme_id   INT NOT NULL,
  document    VARCHAR(255) NOT NULL,
  FOREIGN KEY (scheme_id) REFERENCES schemes(id) ON DELETE CASCADE
);

CREATE TABLE scheme_steps (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  scheme_id   INT NOT NULL,
  step_no     INT NOT NULL,
  instruction TEXT NOT NULL,
  FOREIGN KEY (scheme_id) REFERENCES schemes(id) ON DELETE CASCADE
);

-- structured rules used by /api/eligibility (NULL = "no restriction")
CREATE TABLE scheme_rules (
  scheme_id          INT PRIMARY KEY,
  requires_land      BOOLEAN NOT NULL DEFAULT FALSE,
  min_land_hectares  DECIMAL(6,2),scheme_benefits
  max_land_hectares  DECIMAL(6,2),
  max_annual_income  INT,                 -- in rupees
  min_age            INT,
  max_age            INT,
  karnataka_only     BOOLEAN NOT NULL DEFAULT FALSE,
  allowed_categories VARCHAR(100),        -- e.g. 'SC,ST,OBC,MINORITY'; NULL = all
  allowed_crops      VARCHAR(255),        -- e.g. 'MILLET'; NULL = any crop
  FOREIGN KEY (scheme_id) REFERENCES schemes(id) ON DELETE CASCADE
);


select * from schemes;