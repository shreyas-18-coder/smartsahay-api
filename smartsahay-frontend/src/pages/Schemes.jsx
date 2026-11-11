import { useEffect, useState, useCallback } from 'react';
import { useSearchParams } from 'react-router-dom';
import { getSchemes } from '../services/api';
import { useLanguage } from '../context/LanguageContext';
import SchemeCard from '../components/SchemeCard';
import LoadingSpinner from '../components/LoadingSpinner';
import ErrorMessage from '../components/ErrorMessage';
import './Schemes.css';

const CATEGORIES = [
  'Financial Assistance', 'Crop Insurance', 'Agricultural Credit',
  'Irrigation Subsidy', 'Equipment Subsidy', 'Organic Farming',
  'Renewable Energy', 'Sustainable Farming', 'Agricultural Extension',
  'Natural Farming', 'Education', 'Crop Promotion',
  'Irrigation and Infrastructure', 'Irrigation',
  'Agricultural Infrastructure & Promotion',
];

const STATES = ['All India', 'Karnataka'];
const LEVELS = ['Central', 'State'];

export default function Schemes() {
  const { t, lang } = useLanguage();
  const [searchParams, setSearchParams] = useSearchParams();

  const [filters, setFilters] = useState({
    category: searchParams.get('category') || '',
    state:    searchParams.get('state')    || '',
    level:    searchParams.get('level')    || '',
  });

  const [schemes, setSchemes]   = useState([]);
  const [loading, setLoading]   = useState(true);
  const [error, setError]       = useState(null);
  const [search, setSearch]     = useState('');

  const fetchSchemes = useCallback(async (currentFilters, currentLang) => {
    setLoading(true);
    setError(null);
    try {
      const data = await getSchemes({ ...currentFilters, lang: currentLang });
      setSchemes(data);
    } catch (e) {
      setError(e.message);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchSchemes(filters, lang);

    // Sync URL parameters
    const p = {};
    if (filters.category) p.category = filters.category;
    if (filters.state)    p.state    = filters.state;
    if (filters.level)    p.level    = filters.level;
    setSearchParams(p, { replace: true });
  }, [filters, lang, fetchSchemes, setSearchParams]);

  function updateFilter(key, value) {
    setFilters(prev => ({ ...prev, [key]: value }));
  }

  function clearFilters() {
    setFilters({ category: '', state: '', level: '' });
    setSearch('');
  }

  const displayed = schemes.filter(s =>
      !search ||
      s.name?.toLowerCase().includes(search.toLowerCase()) ||
      s.description?.toLowerCase().includes(search.toLowerCase())
  );

  const activeFilterCount = [filters.category, filters.state, filters.level]
      .filter(Boolean).length;

  return (
      <div className="schemes-page">
        <div className="schemes-header">
          <div>
            <h1>{t('schemesPageTitle')}</h1>
            <p className="schemes-sub">
              {loading
                  ? t('loading')
                  : `${schemes.length} ${t('schemesFoundSuffix')}`}
              {activeFilterCount > 0 && ` · ${activeFilterCount} filter${activeFilterCount > 1 ? 's' : ''} active`}
            </p>
          </div>

          {/* Note: Redundant local [English | ಕನ್ನಡ | हिंदी] buttons removed here */}
        </div>

        {/* ── Filters bar ── */}
        <div className="filters-bar">
          <input
              className="search-input"
              type="search"
              placeholder={t('searchPlaceholder')}
              value={search}
              onChange={e => setSearch(e.target.value)}
              aria-label={t('searchPlaceholder')}
          />

          <select
              value={filters.category}
              onChange={e => updateFilter('category', e.target.value)}
              aria-label={t('allCategories')}
          >
            <option value="">{t('allCategories')}</option>
            {CATEGORIES.map(c => <option key={c} value={c}>{c}</option>)}
          </select>

          <select
              value={filters.state}
              onChange={e => updateFilter('state', e.target.value)}
              aria-label={t('allStates')}
          >
            <option value="">{t('allStates')}</option>
            {STATES.map(s => (
                <option key={s} value={s}>
                  {s === 'All India' ? t('allIndia') : s === 'Karnataka' ? t('karnataka') : s}
                </option>
            ))}
          </select>

          <select
              value={filters.level}
              onChange={e => updateFilter('level', e.target.value)}
              aria-label={t('allLevels')}
          >
            <option value="">{t('allLevels')}</option>
            {LEVELS.map(l => (
                <option key={l} value={l}>
                  {l === 'Central' ? t('central') : t('state')}
                </option>
            ))}
          </select>

          {(activeFilterCount > 0 || search) && (
              <button className="btn-clear" onClick={clearFilters}>
                ✕ {t('cancelBtn')}
              </button>
          )}
        </div>

        {/* ── Results ── */}
        {loading && <LoadingSpinner text={t('loading')} />}
        {error   && <ErrorMessage message={error} onRetry={() => fetchSchemes(filters, lang)} />}

        {!loading && !error && displayed.length === 0 && (
            <div className="empty-state">
              <p>🌾 {t('noSchemesFound')}</p>
              <button className="btn-clear" onClick={clearFilters}>{t('startOverBtn')}</button>
            </div>
        )}

        {!loading && !error && displayed.length > 0 && (
            <div className="schemes-grid">
              {displayed.map(s => <SchemeCard key={s.slug} scheme={s} />)}
            </div>
        )}
      </div>
  );
}