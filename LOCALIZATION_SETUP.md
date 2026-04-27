# Configuration de la Localisation - Aliice iOS

## ✅ Étapes complétées

1. ✅ **Ajout des traductions françaises aux mots Thai**
   - Tous les 946 mots Thai ont maintenant une traduction française
   - Modifiés dans `WordsData.swift`

2. ✅ **Création des fichiers Localizable.strings**
   - `AliiceIOS/en.lproj/Localizable.strings` - Traductions anglaises
   - `AliiceIOS/fr.lproj/Localizable.strings` - Traductions françaises

3. ✅ **Création du helper de localisation**
   - `LocalizationHelper.swift` - Extension `.localized` pour simplifier les appels
   - Fonction `getLocalizedWord()` pour les mots Thai

## 📋 Prochaines étapes (Configuration Xcode)

Pour que la localisation fonctionne correctement dans Xcode, suivez ces étapes :

### 1. Ajouter les fichiers Localizable.strings au projet

**Méthode A: Via Xcode (Recommandée)**

1. Ouvrez `AliiceIOS.xcodeproj` dans Xcode
2. Sélectionnez le projet `AliiceIOS` dans le navigateur
3. Sélectionnez la target `AliiceIOS`
4. Allez dans `Build Phases` > `Copy Bundle Resources`
5. Cliquez le bouton `+` pour ajouter des fichiers
6. Naviguez vers `AliiceIOS/en.lproj/Localizable.strings`
7. Cliquez `Add`
8. Répétez pour `AliiceIOS/fr.lproj/Localizable.strings`

**Méthode B: Via Terminal**

```bash
cd /chemin/vers/AliiceIOS.xcodeproj

# Ajouter en.lproj
xcodebuild -project AliiceIOS.xcodeproj -target AliiceIOS -addResource en.lproj/Localizable.strings

# Ajouter fr.lproj  
xcodebuild -project AliiceIOS.xcodeproj -target AliiceIOS -addResource fr.lproj/Localizable.strings
```

### 2. Configurer les langues supportées

1. Sélectionnez le projet `AliiceIOS` dans Xcode
2. Sélectionnez la target `AliiceIOS`
3. Allez dans `Info` > `Localization`
4. Cliquez le bouton `+` 
5. Sélectionnez `French (fr)`
6. Les fichiers Localizable.strings des deux langues devraient apparaître

### 3. Remplacer les strings hardcodés par NSLocalizedString

Les fichiers de vues doivent utiliser l'extension `.localized` :

```swift
// Avant
Text("Play")

// Après
Text("Play".localized)
```

**Exemple avec StartView.swift** :

```swift
Text("Aliice".localized)
Text("Learn Thai".localized)
Text("Play".localized)
Text("How to Learn".localized)
```

### 4. Localiser les mots Thai

Pour afficher un mot Thai dans la langue correcte :

```swift
// Avant
Text(word.english)

// Après
Text(getLocalizedWord(word))
```

Ou dans les vues :

```swift
Text(LocalizationManager.shared.getLocalizedWord(word))
```

## 🎯 Mots Thai Localisés

**Exemple de quelques mots :**

| ID | English | Français |
|----|---------| ---------|
| cat | chat | chat |
| dog | chien | chien |
| cow | vache | vache |
| apple | pomme | pomme |
| banana | banane | banane |

**Tous les 946 mots ont des traductions !**

## 📊 Textes de l'Interface Localisés

Les 30+ strings principaux de l'interface ont des traductions françaises :

| English | Français |
|---------|----------|
| Aliice | Aliice |
| Learn Thai | Apprendre le Thaï |
| Play | Jouer |
| How to Learn | Comment apprendre |
| Score | Score |
| Best | Meilleur |
| Level | Niveau |
| Badges | Badges |
| Profile | Profil |
| Stats | Stats |
| ... et plus | ... et plus |

## 🔧 Utilisation dans le Code

### Extension String

```swift
// Utilisation simple
Text("Play".localized)

// Avec arguments (si nécessaire)
Text(String(format: "Score: %d".localized, game.score))
```

### Classe LocalizationManager

```swift
// Obtenir la langue actuelle
let currentLanguage = LocalizationManager.shared.currentLanguage

// Obtenir un mot localisé
let frenchWord = LocalizationManager.shared.getLocalizedWord(word)
```

### Fonction Helper

```swift
// Fonction autonome pour localiser les mots
let localizedWord = getLocalizedWord(word)
```

## 📝 Fichiers modifiés

- ✅ `WordsData.swift` - Ajout des traductions françaises
- ✅ `LocalizationHelper.swift` - Nouvelles helper pour localisation
- ✅ `StartView.swift` - Utilisation de `.localized`
- ⏳ Autres vues - À mettre à jour

## ⚙️ Configuration dans Info.plist

L'app est prête pour supporter :
- Anglais (en)
- Français (fr)

Vous pouvez ajouter d'autres langues en créant :
- `es.lproj/Localizable.strings` pour l'espagnol
- `de.lproj/Localizable.strings` pour l'allemand
- etc.

## ✨ Prochaines étapes

1. **Immediate** : Ajouter les fichiers Localizable.strings au projet Xcode
2. **Court terme** : Remplacer tous les hardcoded strings dans les vues par `.localized`
3. **Court terme** : Mettre à jour CategoryPickerView.swift, PlayView.swift, SettingsView.swift
4. **Moyen terme** : Ajouter d'autres langues (espagnol, allemand, etc.)
5. **Moyen terme** : Tester la localisation sur device/simulateur

## 🧪 Comment tester

### Simulateur iOS

1. Ouvrez le scheme en Xcode
2. Allez dans `Scheme` > `Edit Scheme`
3. Sélectionnez `Run`
4. Sélectionnez l'onglet `Options`
5. Changez `App Language` à `French`
6. Lancez l'app - elle devrait afficher en français

### Device réel

1. Allez dans Réglages > Général > Langue et Région
2. Changez la langue à Français
3. Lancez Aliice - elle devrait afficher en français

## 📞 Support

Pour toute question sur la localisation, consultez :
- [Apple Localization Documentation](https://developer.apple.com/documentation/foundation/nslocalization)
- [SwiftUI Localization Guide](https://developer.apple.com/design/human-interface-guidelines/ios/patterns/accessing-user-data/)
