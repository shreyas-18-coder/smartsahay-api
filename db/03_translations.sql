USE smartsahay;

ALTER TABLE schemes
  ADD COLUMN last_verified DATE NULL AFTER contact_info,
  ADD COLUMN active BOOLEAN NOT NULL DEFAULT TRUE AFTER last_verified;

CREATE TABLE scheme_translations (
  scheme_id   INT NOT NULL,
  lang        CHAR(2) NOT NULL,          -- 'kn' or 'hi'
  name        VARCHAR(200) NOT NULL,
  description TEXT NOT NULL,
  PRIMARY KEY (scheme_id, lang),
  FOREIGN KEY (scheme_id) REFERENCES schemes(id) ON DELETE CASCADE
);

-- DRAFT translations for 3 schemes, to be reviewed by a native speaker
INSERT INTO scheme_translations (scheme_id, lang, name, description) VALUES
((SELECT id FROM schemes WHERE slug='pm-kisan-income-support-scheme'), 'hi',
 'पीएम-किसान आय सहायता योजना',
 'यह केंद्र सरकार की योजना है जो भूमिधारक किसान परिवारों को कृषि सामग्री खरीदने और घरेलू जरूरतें पूरी करने के लिए सीधे आय सहायता देती है।'),
((SELECT id FROM schemes WHERE slug='pm-kisan-income-support-scheme'), 'kn',
 'ಪಿಎಂ-ಕಿಸಾನ್ ಆದಾಯ ಬೆಂಬಲ ಯೋಜನೆ',
 'ಇದು ಕೇಂದ್ರ ಸರ್ಕಾರದ ಯೋಜನೆಯಾಗಿದ್ದು, ಭೂಮಿ ಹೊಂದಿರುವ ರೈತ ಕುಟುಂಬಗಳಿಗೆ ಕೃಷಿ ಸಾಮಗ್ರಿಗಳನ್ನು ಖರೀದಿಸಲು ಮತ್ತು ಮನೆಯ ಅಗತ್ಯಗಳನ್ನು ಪೂರೈಸಲು ನೇರ ಆದಾಯ ಬೆಂಬಲ ನೀಡುತ್ತದೆ.'),
((SELECT id FROM schemes WHERE slug='pradhan-mantri-fasal-bima-yojana'), 'hi',
 'प्रधानमंत्री फसल बीमा योजना (पीएमएफबीवाई)',
 'यह एक समावेशी फसल बीमा योजना है, जो प्राकृतिक आपदाओं से फसल को होने वाले नुकसान के विरुद्ध किसानों को व्यापक वित्तीय सुरक्षा देती है।'),
((SELECT id FROM schemes WHERE slug='pradhan-mantri-fasal-bima-yojana'), 'kn',
 'ಪ್ರಧಾನ ಮಂತ್ರಿ ಫಸಲ್ ಬಿಮಾ ಯೋಜನೆ (ಪಿಎಂಎಫ್‌ಬಿವೈ)',
 'ತಡೆಯಲಾಗದ ನೈಸರ್ಗಿಕ ಅಪಾಯಗಳಿಂದ ಬೆಳೆ ನಷ್ಟವಾದಾಗ ರೈತರಿಗೆ ಸಮಗ್ರ ಆರ್ಥಿಕ ರಕ್ಷಣೆ ನೀಡುವ, ಎಲ್ಲರನ್ನೂ ಒಳಗೊಳ್ಳುವ ಬೆಳೆ ವಿಮಾ ಯೋಜನೆ.'),
((SELECT id FROM schemes WHERE slug='kisan-credit-card-scheme'), 'hi',
 'किसान क्रेडिट कार्ड (केसीसी) योजना',
 'यह ऋण योजना अनौपचारिक साहूकारों की जगह संस्थागत बैंकिंग देती है, ताकि खेती और संबद्ध गतिविधियों के लिए समय पर और आसान कर्ज मिल सके।'),
((SELECT id FROM schemes WHERE slug='kisan-credit-card-scheme'), 'kn',
 'ಕಿಸಾನ್ ಕ್ರೆಡಿಟ್ ಕಾರ್ಡ್ (ಕೆಸಿಸಿ) ಯೋಜನೆ',
 'ಅನೌಪಚಾರಿಕ ಲೇವಾದೇವಿದಾರರ ಬದಲಿಗೆ ಬ್ಯಾಂಕ್ ಮೂಲಕ ಕೃಷಿ ಮತ್ತು ಸಂಬಂಧಿತ ಚಟುವಟಿಕೆಗಳಿಗೆ ಸಕಾಲದಲ್ಲಿ, ಸುಲಭವಾಗಿ ಸಾಲ ಒದಗಿಸುವ ಯೋಜನೆ.');

SELECT lang, COUNT(*) FROM scheme_translations GROUP BY lang;