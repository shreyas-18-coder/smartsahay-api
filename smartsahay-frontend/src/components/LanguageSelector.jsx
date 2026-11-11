import { useLanguage } from '../context/LanguageContext';

export default function LanguageSelector() {
    const { lang, setLang } = useLanguage();

    return (
        <div className="language-selector-wrapper">
            <select
                value={lang}
                onChange={(e) => setLang(e.target.value)}
                aria-label="Language selection"
                className="lang-select"
            >
                <option value="en">English</option>
                <option value="kn">ಕನ್ನಡ</option>
                <option value="hi">हिन्दी</option>
            </select>
        </div>
    );
}