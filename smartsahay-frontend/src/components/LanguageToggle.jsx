import React from 'react';
import { useLanguage } from '../context/LanguageContext';

export default function LanguageToggle() {
    const { lang, setLang } = useLanguage();

    const languages = [
        { code: 'kn', label: 'ಕನ್ನಡ' },
        { code: 'en', label: 'English' },
        { code: 'hi', label: 'हिन्दी' },
    ];

    return (
        <div style={styles.container}>
            {languages.map((item) => {
                const isActive = lang === item.code;
                return (
                    <button
                        key={item.code}
                        type="button"
                        onClick={() => setLang(item.code)}
                        style={{
                            ...styles.btn,
                            ...(isActive ? styles.activeBtn : styles.inactiveBtn),
                        }}
                    >
                        {item.label}
                    </button>
                );
            })}
        </div>
    );
}

const styles = {
    container: {
        display: 'inline-flex',
        backgroundColor: 'rgba(255, 255, 255, 0.15)',
        borderRadius: '20px',
        padding: '3px',
        gap: '2px',
        alignItems: 'center',
        marginLeft: '12px',
    },
    btn: {
        border: 'none',
        outline: 'none',
        cursor: 'pointer',
        padding: '5px 12px',
        borderRadius: '16px',
        fontSize: '13px',
        fontWeight: '500',
        transition: 'all 0.2s ease',
    },
    activeBtn: {
        backgroundColor: '#ffffff',
        color: '#1b4332', // Dark green matching your theme
        boxShadow: '0 1px 3px rgba(0,0,0,0.2)',
    },
    inactiveBtn: {
        backgroundColor: 'transparent',
        color: 'rgba(255, 255, 255, 0.85)',
    },
};