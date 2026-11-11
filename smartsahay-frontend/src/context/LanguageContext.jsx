import { createContext, useContext, useState, useEffect, useCallback } from 'react';
import { translations } from '../locales/translations';

const LanguageContext = createContext(null);

export function LanguageProvider({ children }) {
    const [lang, setLangState] = useState(() => {
        return localStorage.getItem('smartsahay_lang') || 'en';
    });

    const setLang = useCallback((newLang) => {
        if (['kn','en','hi'].includes(newLang)) {
            localStorage.setItem('smartsahay_lang', newLang);
            setLangState(newLang);
        }
    }, []);

    useEffect(() => {
        document.documentElement.lang = lang;
    }, [lang]);

    const t = useCallback((key) => {
        if (translations[lang] && translations[lang][key]) {
            return translations[lang][key];
        }
        return translations.en[key] || key;
    }, [lang]);

    return (
        <LanguageContext.Provider value={{ lang, setLang, t }}>
            {children}
        </LanguageContext.Provider>
    );
}

export const useLanguage = () => useContext(LanguageContext);