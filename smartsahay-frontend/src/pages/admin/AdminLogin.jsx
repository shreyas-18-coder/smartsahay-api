import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { useLanguage } from '../../context/LanguageContext';
import './AdminLogin.css';

export default function AdminLogin() {
  const { login, loading, error, isAdmin } = useAuth();
  const { t } = useLanguage();
  const navigate = useNavigate();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPass, setShowPass] = useState(false);

  // Already logged in — bounce to dashboard
  useEffect(() => {
    if (isAdmin) navigate('/admin', { replace: true });
  }, [isAdmin, navigate]);

  async function handleSubmit(e) {
    e.preventDefault();
    const ok = await login(username, password);
    if (ok) navigate('/admin', { replace: true });
  }

  return (
      <div className="login-page">
        <div className="login-card">
          <div className="login-header">
            <span className="login-icon">🔐</span>
            <h1>{t('adminLoginTitle')}</h1>
            <p>{t('adminLoginSubtitle')}</p>
          </div>

          <form onSubmit={handleSubmit} noValidate className="login-form">
            <div className="form-group">
              <label htmlFor="username">{t('usernameLabel')}</label>
              <input
                  id="username"
                  type="text"
                  autoComplete="username"
                  value={username}
                  onChange={e => setUsername(e.target.value)}
                  required
                  disabled={loading}
                  placeholder="admin"
              />
            </div>

            <div className="form-group">
              <label htmlFor="password">{t('passwordLabel')}</label>
              <div className="pass-wrap">
                <input
                    id="password"
                    type={showPass ? 'text' : 'password'}
                    autoComplete="current-password"
                    value={password}
                    onChange={e => setPassword(e.target.value)}
                    required
                    disabled={loading}
                    placeholder="••••••••"
                />
                <button
                    type="button"
                    className="show-pass"
                    onClick={() => setShowPass(p => !p)}
                    aria-label={showPass ? 'Hide password' : 'Show password'}
                >
                  {showPass ? '🙈' : '👁'}
                </button>
              </div>
            </div>

            {error && <p className="login-error" role="alert">⚠ {error}</p>}

            <button type="submit" className="btn-login" disabled={loading || !username || !password}>
              {loading ? t('loading') : t('signInBtn')}
            </button>
          </form>

          <p className="login-note">
            {t('tokenNotice')}
          </p>
        </div>
      </div>
  );
}