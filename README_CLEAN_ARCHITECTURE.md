# Blog App - Clean Architecture Demo

Cette application Flutter sert de démonstration pour le bootcamp sur l'implémentation de la Clean Architecture.

## 🏗️ Architecture

L'application suit les principes de la Clean Architecture avec trois couches principales :

### 📱 Presentation Layer (Couche Présentation)
- **Pages** : Interface utilisateur (BlogListPage)
- **Widgets** : Composants réutilisables (BlogPostCard)
- **BLoC** : Gestion d'état (BlogBloc, BlogEvent, BlogState)

### 🎯 Domain Layer (Couche Domaine)
- **Entities** : Objets métier purs (BlogPost)
- **Use Cases** : Logique métier (GetAllBlogPosts, GetBlogPostById)
- **Repositories** : Interfaces des repositories (BlogRepository)

### 💾 Data Layer (Couche Données)
- **Models** : Objets de données avec sérialisation (BlogPostModel)
- **Data Sources** : Sources de données (Remote/Local)
- **Repositories** : Implémentations concrètes (BlogRepositoryImpl)

### 🔧 Core
- **Error** : Gestion des erreurs (Failures)
- **Use Cases** : Classes de base pour les cas d'usage
- **Network** : Informations réseau

## 📁 Structure des dossiers

```
lib/
├── core/
│   ├── error/
│   │   └── failures.dart
│   ├── network/
│   │   └── network_info.dart
│   ├── usecases/
│   │   └── usecase.dart
│   └── demo_data.dart
├── features/
│   └── blog/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── blog_local_data_source.dart
│       │   │   └── blog_remote_data_source.dart
│       │   ├── models/
│       │   │   └── blog_post_model.dart
│       │   └── repositories/
│       │       └── blog_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── blog_post.dart
│       │   ├── repositories/
│       │   │   └── blog_repository.dart
│       │   └── usecases/
│       │       ├── get_all_blog_posts.dart
│       │       └── get_blog_post_by_id.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── blog_bloc.dart
│           │   ├── blog_event.dart
│           │   └── blog_state.dart
│           ├── pages/
│           │   └── blog_list_page.dart
│           └── widgets/
│               └── blog_post_card.dart
├── injection_container.dart
└── main.dart
```

## 🚀 Technologies utilisées

- **Flutter** : Framework de développement
- **Dart** : Langage de programmation
- **flutter_bloc** : Gestion d'état
- **dartz** : Programmation fonctionnelle (Either, Right, Left)
- **equatable** : Comparaisons d'objets
- **get_it** : Injection de dépendances

## 🎓 Concepts démontrés

### 1. Separation of Concerns
Chaque couche a une responsabilité spécifique et ne dépend que des couches inférieures.

### 2. Dependency Inversion
Les couches supérieures ne dépendent que d'abstractions, pas d'implémentations concrètes.

### 3. Dependency Injection
Utilisation de GetIt pour l'injection de dépendances.

### 4. Error Handling
Gestion des erreurs avec le pattern Either (Success/Failure).

### 5. State Management
Gestion d'état avec le pattern BLoC.

### 6. Testing
Structure facilitant les tests unitaires et d'intégration.

## 🏃‍♂️ Comment lancer l'application

1. **Installer les dépendances** :
   ```bash
   flutter pub get
   ```

2. **Lancer l'application** :
   ```bash
   flutter run
   ```

3. **Lancer sur le web** :
   ```bash
   flutter run -d chrome
   ```

## 🧪 Tests

```bash
# Tests unitaires
flutter test

# Analyse du code
flutter analyze

# Formatage du code
dart format .
```

## 📝 Points clés pour le bootcamp

### Avantages de la Clean Architecture :
- ✅ **Testabilité** : Chaque couche peut être testée indépendamment
- ✅ **Maintenabilité** : Code organisé et facile à modifier
- ✅ **Scalabilité** : Facile d'ajouter de nouvelles fonctionnalités
- ✅ **Flexibilité** : Changement de technologie sans impact sur la logique métier

### Flux de données :
1. **UI** envoie un événement au **BLoC**
2. **BLoC** appelle un **Use Case**
3. **Use Case** utilise le **Repository**
4. **Repository** récupère les données des **Data Sources**
5. Les données remontent jusqu'à l'**UI**

### Pattern Either :
```dart
// Succès
return Right(data);

// Échec
return Left(ServerFailure(message: 'Erreur serveur'));
```

## 🔄 Améliorations possibles

- Ajout de tests unitaires et d'intégration
- Implémentation réelle de l'API REST
- Ajout du cache avec SharedPreferences
- Gestion de la connectivité réseau
- Pagination des articles
- Recherche et filtres
- Mode hors ligne
- Dark mode
