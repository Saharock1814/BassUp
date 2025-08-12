# Localization Guide for BassUp

This document explains how localization is implemented in the BassUp app and how to add new languages.

## 🌍 Current Supported Languages

- **English (en)** - Default language
- **Russian (ru)** - Full translation available

## 📁 File Structure

```
BassUp/
├── Resources/
│   ├── Localizable.strings          # English (base) localization
│   └── ru.lproj/
│       └── Localizable.strings      # Russian localization
├── Core/
│   ├── Extensions/
│   │   └── String+Localization.swift # Localization utilities
│   └── Managers/
│       └── LanguageManager.swift    # Language management
└── Features/
    └── Settings/
        └── Views/
            └── LanguageSettingsView.swift # Language selection UI
```

## 🔧 How Localization Works

### 1. String Keys
All user-facing strings are defined as keys in the `Localizable.strings` files:

```swift
// In Localizable.strings (English)
"app_name" = "BassUp";
"auth_welcome_back" = "Welcome back!";

// In ru.lproj/Localizable.strings (Russian)
"app_name" = "BassUp";
"auth_welcome_back" = "С возвращением!";
```

### 2. String Extension
The `String+Localization.swift` extension provides easy access to localized strings:

```swift
// Static keys for type safety
extension String {
    static let appName = "app_name"
    static let authWelcomeBack = "auth_welcome_back"
}

// Usage in views
Text(String.appName.localized)
Text(String.authWelcomeBack.localized)
```

### 3. Language Manager
The `LanguageManager` handles:
- Language switching
- Persistence of language preference
- System language detection
- Dynamic language updates

## ➕ Adding a New Language

### Step 1: Create Language Bundle
1. Create a new folder: `BassUp/Resources/[language_code].lproj/`
2. Copy `Localizable.strings` from the base language
3. Translate all strings in the new file

Example for Spanish:
```
BassUp/Resources/es.lproj/Localizable.strings
```

### Step 2: Update Language Enum
Add the new language to `LanguageManager.swift`:

```swift
enum Language: String, CaseIterable {
    case english = "en"
    case russian = "ru"
    case spanish = "es"  // Add this
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .russian: return "Русский"
        case .spanish: return "Español"  // Add this
        }
    }
    
    var nativeName: String {
        switch self {
        case .english: return "English"
        case .russian: return "Русский"
        case .spanish: return "Español"  // Add this
        }
    }
    
    var flag: String {
        switch self {
        case .english: return "🇺🇸"
        case .russian: return "🇷🇺"
        case .spanish: return "🇪🇸"  // Add this
        }
    }
}
```

### Step 3: Update Info.plist
Add the language code to the supported localizations:

```xml
<key>CFBundleLocalizations</key>
<array>
    <string>en</string>
    <string>ru</string>
    <string>es</string>  <!-- Add this -->
</array>
```

### Step 4: Update System Language Detection
Update the `getSystemLanguage()` method in `LanguageManager`:

```swift
private func getSystemLanguage() -> Language {
    let preferredLanguage = Locale.preferredLanguages.first ?? "en"
    
    if preferredLanguage.hasPrefix("ru") {
        return .russian
    } else if preferredLanguage.hasPrefix("es") {
        return .spanish  // Add this
    } else {
        return .english
    }
}
```

## 📝 Translation Guidelines

### 1. String Length
- Consider that translated text may be longer or shorter
- Use flexible layouts that can accommodate different text lengths
- Test UI with longer translations (German, Finnish, etc.)

### 2. Cultural Considerations
- Adapt content for cultural differences
- Consider local music terminology
- Adjust examples to be culturally relevant

### 3. Technical Terms
- Maintain consistency in music theory terminology
- Use standard translations for musical terms
- Consider creating a glossary for translators

### 4. Pluralization
- Different languages have different pluralization rules
- Use appropriate pluralization methods:

```swift
// English
"lesson_count" = "%d lesson";
"lesson_count_plural" = "%d lessons";

// Russian (has 3 plural forms)
"lesson_count_0" = "%d уроков";
"lesson_count_1" = "%d урок";
"lesson_count_2" = "%d урока";
```

## 🧪 Testing Localization

### 1. Simulator Testing
1. Change device language in Settings
2. Restart the app
3. Verify all strings are translated

### 2. Runtime Testing
1. Use the language settings in the app
2. Switch between languages
3. Verify persistence across app launches

### 3. UI Testing
1. Test with different text lengths
2. Verify layouts work with all languages
3. Check for text overflow or truncation

## 🔍 Common Issues

### 1. Missing Translations
- If a key is missing, the app falls back to the base language
- Check that all keys are present in all language files

### 2. Text Overflow
- Use flexible layouts (HStack, VStack with spacing)
- Avoid fixed widths for text containers
- Test with longer translations

### 3. Font Issues
- Some languages may require different fonts
- Test with languages that use different scripts (Cyrillic, Arabic, etc.)

## 📚 Resources

### Translation Tools
- [Apple's Localization Guide](https://developer.apple.com/documentation/xcode/localization)
- [Lokalise](https://lokalise.com/) - Professional translation management
- [Crowdin](https://crowdin.com/) - Community translation platform

### Music Terminology
- [IMSLP](https://imslp.org/) - International Music Score Library Project
- [Grove Music Online](https://www.oxfordmusiconline.com/) - Music encyclopedia

## 🤝 Contributing Translations

1. Fork the repository
2. Create a new language bundle
3. Translate all strings in `Localizable.strings`
4. Test the translation thoroughly
5. Submit a pull request

### Translation Checklist
- [ ] All strings translated
- [ ] Music terminology consistent
- [ ] Cultural adaptations made
- [ ] UI tested with translation
- [ ] Pluralization rules implemented
- [ ] Documentation updated

---

For questions about localization, please contact the development team or create an issue in the repository.
