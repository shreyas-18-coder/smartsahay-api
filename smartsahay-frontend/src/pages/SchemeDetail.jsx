import { useEffect, useState, useCallback } from 'react';
import { useParams, Link, useNavigate } from 'react-router-dom';
import { getScheme } from '../services/api';
import { useAuth } from '../context/AuthContext';
import { useLanguage } from '../context/LanguageContext';
import LoadingSpinner from '../components/LoadingSpinner';
import ErrorMessage from '../components/ErrorMessage';
import './SchemeDetail.css';

const LEVEL_BADGE = { Central: 'badge-blue', State: 'badge-orange' };
const MODE_ICON   = { Online: '🌐', Offline: '🏢', Both: '🌐🏢' };

export default function SchemeDetail() {
  const { slug } = useParams();
  const { isAdmin } = useAuth();
  const { t, lang } = useLanguage();
  const navigate = useNavigate();

  const [scheme, setScheme] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError]     = useState(null);

  const load = useCallback(async (currentLang) => {
    setLoading(true);
    setError(null);
    try {
      const data = await getScheme(slug, currentLang);
      setScheme(data);
    } catch (e) {
      setError(e.status === 404 ? t('noSchemesFound') : e.message);
    } finally {
      setLoading(false);
    }
  }, [slug, t]);

  useEffect(() => {
    load(lang);
  }, [load, lang]);

  if (loading) return <LoadingSpinner text={t('loading')} />;
  if (error) return (
      <div className="detail-page">
        <ErrorMessage message={error} onRetry={() => load(lang)} />
        <div style={{ textAlign: 'center', marginTop: '1rem' }}>
          <Link to="/schemes" className="back-link">← {t('schemes')}</Link>
        </div>
      </div>
  );

  return (
      <div className="detail-page">
        {/* ── Breadcrumb ── */}
        <nav className="breadcrumb" aria-label="breadcrumb">
          <Link to="/schemes">{t('schemes')}</Link>
          <span aria-hidden="true">›</span>
          <span>{scheme.name}</span>
        </nav>

        {/* ── Header ── */}
        <div className="detail-header">
          <div className="detail-badges">
          <span className={`badge ${LEVEL_BADGE[scheme.level] || 'badge-blue'}`}>
            {scheme.level === 'Central' ? t('central') : t('state')}
          </span>
            <span className="badge badge-gray">
            {scheme.state === 'All India' ? t('allIndia') : scheme.state === 'Karnataka' ? t('karnataka') : scheme.state}
          </span>
            <span className="badge badge-green">{scheme.category}</span>
          </div>

          <div className="detail-title-row">
            <h1 className="detail-title">{scheme.name}</h1>
            {/* Note: Redundant local language toggle buttons removed from here */}
          </div>

          <p className="detail-desc">{scheme.description}</p>

          {/* ── Meta cards ── */}
          <div className="meta-grid">
            <MetaItem
                icon="🌐"
                label={t('modeFormLabel')}
                value={`${MODE_ICON[scheme.applicationMode] || '🌐'} ${
                    scheme.applicationMode === 'Online'
                        ? t('online')
                        : scheme.applicationMode === 'Offline'
                            ? t('offline')
                            : t('both')
                }`}
            />
            {scheme.whereToApply && (
                <MetaItem icon="📍" label={t('whereToApplyLabel')} value={scheme.whereToApply} />
            )}
            {scheme.lastDate && (
                <MetaItem icon="📅" label={t('lastDateLabel')} value={scheme.lastDate} />
            )}
            {scheme.contactInfo && (
                <MetaItem icon="📞" label={t('contactInfoLabel')} value={scheme.contactInfo} />
            )}
            {scheme.lastVerified && (
                <MetaItem icon="✔" label={t('lastVerifiedLabel')} value={scheme.lastVerified} />
            )}
          </div>

          <div className="detail-actions">
            {scheme.officialLink && (
                <a href={scheme.officialLink} target="_blank" rel="noopener noreferrer" className="btn btn-primary-green">
                  {t('applyOnPortal')} ↗
                </a>
            )}
            <Link to="/eligibility" className="btn btn-outline-green">
              {t('checkMyEligibility')}
            </Link>
            {isAdmin && (
                <button className="btn btn-outline-admin" onClick={() => navigate(`/admin/schemes/${slug}/edit`)}>
                  ✏ {t('schemeFormEditTitle')}
                </button>
            )}
          </div>
        </div>

        {/* ── Detail sections ── */}
        <div className="detail-body">
          <DetailSection title={t('benefitsSectionTitle')} icon="🎁" items={scheme.benefits} />
          <DetailSection title={t('eligibilitySectionTitle')} icon="✅" items={scheme.eligibility} />
          <DetailSection title={t('documentsSectionTitle')} icon="📄" items={scheme.documents} />
          <DetailSection title={t('stepsSectionTitle')} icon="🪜" items={scheme.steps} ordered />
        </div>
      </div>
  );
}

function MetaItem({ icon, label, value }) {
  return (
      <div className="meta-item">
        <span className="meta-icon">{icon}</span>
        <div>
          <p className="meta-label">{label}</p>
          <p className="meta-value">{value}</p>
        </div>
      </div>
  );
}

function DetailSection({ title, icon, items, ordered = false }) {
  if (!items || items.length === 0) return null;
  const Tag = ordered ? 'ol' : 'ul';
  return (
      <section className="detail-section">
        <h2 className="detail-section-title">{icon} {title}</h2>
        <Tag className={`detail-list ${ordered ? 'ordered' : ''}`}>
          {items.map((item, i) => <li key={i}>{item}</li>)}
        </Tag>
      </section>
  );
}