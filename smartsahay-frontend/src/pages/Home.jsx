import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { getHealth } from '../services/api';
import { useLanguage } from '../context/LanguageContext';
import './Home.css';

export default function Home() {
  const [health, setHealth] = useState(null);
  const { t } = useLanguage();

  useEffect(() => {
    getHealth()
        .then(setHealth)
        .catch(() => setHealth({ status: 'UNKNOWN' }));
  }, []);

  const features = [
    {
      icon: '🔍',
      title: t('cardBrowseTitle'),
      desc: t('cardBrowseDesc'),
      to: '/schemes',
    },
    {
      icon: '✅',
      title: t('cardEligibilityTitle'),
      desc: t('cardEligibilityDesc'),
      to: '/eligibility',
    },
    {
      icon: '🌐',
      title: t('cardMultilingualTitle'),
      desc: t('cardMultilingualDesc'),
      to: '/schemes',
    },
    {
      icon: '🛡️',
      title: t('cardAdminTitle'),
      desc: t('cardAdminDesc'),
      to: '/admin/login',
    },
  ];

  const categories = [
    { key: 'Financial Assistance', label: t('catFinancialAssistance') },
    { key: 'Crop Insurance',       label: t('catCropInsurance') },
    { key: 'Agricultural Credit',  label: t('catAgriCredit') },
    { key: 'Irrigation Subsidy',   label: t('catIrrigationSubsidy') },
    { key: 'Equipment Subsidy',    label: t('catEquipmentSubsidy') },
    { key: 'Organic Farming',      label: t('catOrganicFarming') },
    { key: 'Renewable Energy',     label: t('catRenewableEnergy') },
    { key: 'Natural Farming',      label: t('catNaturalFarming') },
  ];

  return (
      <div className="home">
        {/* ── Hero ── */}
        <section className="hero">
          <div className="hero-inner">
            <span className="hero-eyebrow">{t('heroBadge')}</span>
            <h1 className="hero-title">{t('heroTitle')}</h1>
            <p className="hero-sub">{t('heroSubtitle')}</p>

            <div className="hero-cta">
              <Link to="/eligibility" className="btn btn-primary">
                {t('checkMyEligibility')}
              </Link>
              <Link to="/schemes" className="btn btn-secondary">
                {t('browseAllSchemes')}
              </Link>
            </div>

            {health && (
                <p className={`api-status ${health.status === 'UP' ? 'up' : 'down'}`}>
                  {health.status === 'UP'
                      ? `✔ ${t('apiConnected')} · ${health.schemesCount} ${t('schemesLoaded')}`
                      : t('apiUnavailable')}
                </p>
            )}
          </div>
          <div className="hero-art" aria-hidden="true">🌾</div>
        </section>

        {/* ── Features ── */}
        <section className="section">
          <h2 className="section-title">{t('whatTitle')}</h2>
          <div className="features-grid">
            {features.map((f) => (
                <Link to={f.to} key={f.title} className="feature-card">
                  <span className="feature-icon">{f.icon}</span>
                  <h3>{f.title}</h3>
                  <p>{f.desc}</p>
                </Link>
            ))}
          </div>
        </section>

        {/* ── Categories ── */}
        <section className="section section-alt">
          <h2 className="section-title">{t('categoriesTitle')}</h2>
          <div className="category-chips">
            {categories.map((c) => (
                <Link
                    key={c.key}
                    to={`/schemes?category=${encodeURIComponent(c.key)}`}
                    className="chip"
                >
                  {c.label}
                </Link>
            ))}
          </div>
        </section>

        {/* ── Eligibility CTA ── */}
        <section className="cta-section">
          <div className="cta-inner">
            <h2>{t('readyTitle')}</h2>
            <p>{t('readySubtitle')}</p>
            <Link to="/eligibility" className="btn btn-primary btn-large">
              {t('getStartedBtn')}
            </Link>
          </div>
        </section>
      </div>
  );
}