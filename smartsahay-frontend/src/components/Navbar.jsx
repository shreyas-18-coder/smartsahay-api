import { NavLink, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useLanguage } from '../context/LanguageContext';
import LanguageToggle from './LanguageToggle';
import './Navbar.css';

export default function Navbar() {
    const { isAdmin, logout } = useAuth();
    const { t } = useLanguage();
    const navigate = useNavigate();

    function handleLogout() {
        logout();
        navigate('/admin/login');
    }

    return (
        <nav className="navbar">
            <NavLink to="/" className="navbar-brand">
                <span className="brand-icon">🌾</span>
                <span className="brand-text">{t('appTitle')}</span>
            </NavLink>

            <ul className="navbar-links">
                <li>
                    <NavLink to="/" end className={({ isActive }) => isActive ? 'active' : ''}>
                        {t('home')}
                    </NavLink>
                </li>
                <li>
                    <NavLink to="/schemes" className={({ isActive }) => isActive ? 'active' : ''}>
                        {t('schemes')}
                    </NavLink>
                </li>
                <li>
                    <NavLink to="/eligibility" className={({ isActive }) => isActive ? 'active' : ''}>
                        {t('checkEligibility')}
                    </NavLink>
                </li>
                {isAdmin ? (
                    <>
                        <li>
                            <NavLink to="/admin" className={({ isActive }) => isActive ? 'active' : ''}>
                                {t('admin')}
                            </NavLink>
                        </li>
                        <li>
                            <button className="btn-logout" onClick={handleLogout}>
                                {t('logout')}
                            </button>
                        </li>
                    </>
                ) : (
                    <li>
                        <NavLink to="/admin/login" className={({ isActive }) => isActive ? 'active' : ''}>
                            {t('admin')}
                        </NavLink>
                    </li>
                )}
                <li className="navbar-lang-item">
                    <LanguageToggle />
                </li>
            </ul>
        </nav>
    );
}