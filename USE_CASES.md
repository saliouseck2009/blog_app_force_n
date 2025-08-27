# Use Cases Disponibles

Cette application utilise le pattern Clean Architecture avec des Use Cases pour chaque opération métier.

## 🔐 Authentication Use Cases

### 1. LoginUseCase
- **Fichier**: `features/auth/domain/usecases/login_usecase.dart`
- **Méthode repository**: `AuthRepository.login(AuthCredentials)`
- **Description**: Connecter un utilisateur avec email/mot de passe
- **Paramètres**: `AuthCredentials` (email, password)
- **Retour**: `DataState<User>`

### 2. SignUpUseCase
- **Fichier**: `features/auth/domain/usecases/signup_usecase.dart`
- **Méthode repository**: `AuthRepository.signUp(SignUpData)`
- **Description**: Inscrire un nouvel utilisateur
- **Paramètres**: `SignUpData` (nom, email, password, etc.)
- **Retour**: `DataState<User>`

### 3. GetCurrentUserUseCase
- **Fichier**: `features/auth/domain/usecases/get_current_user_usecase.dart`
- **Méthode repository**: `AuthRepository.getCurrentUser()`
- **Description**: Récupérer l'utilisateur actuellement connecté
- **Paramètres**: `NoParams`
- **Retour**: `DataState<User?>`

### 4. LogoutUseCase ✨ (nouveau)
- **Fichier**: `features/auth/domain/usecases/logout_usecase.dart`
- **Méthode repository**: `AuthRepository.logout()`
- **Description**: Déconnecter l'utilisateur actuel
- **Paramètres**: `NoParams`
- **Retour**: `DataState<void>`

### 5. IsLoggedInUseCase ✨ (nouveau)
- **Fichier**: `features/auth/domain/usecases/is_logged_in_usecase.dart`
- **Méthode repository**: `AuthRepository.isLoggedIn()`
- **Description**: Vérifier si un utilisateur est connecté
- **Paramètres**: `NoParams`
- **Retour**: `Future<bool>` (pas DataState car pas d'erreur possible)

### 6. UpdateProfileUseCase ✨ (nouveau)
- **Fichier**: `features/auth/domain/usecases/update_profile_usecase.dart`
- **Méthode repository**: `AuthRepository.updateProfile(User)`
- **Description**: Mettre à jour le profil utilisateur
- **Paramètres**: `User` (données modifiées)
- **Retour**: `DataState<User>`

## 📝 Blog Use Cases

### 1. GetAllBlogPosts
- **Fichier**: `features/blog/domain/usecases/get_all_blog_posts.dart`
- **Méthode repository**: `BlogRepository.getAllBlogPosts()`
- **Description**: Récupérer tous les articles de blog
- **Paramètres**: `NoParams`
- **Retour**: `DataState<List<BlogPost>>`

### 2. GetBlogPostById
- **Fichier**: `features/blog/domain/usecases/get_blog_post_by_id.dart`
- **Méthode repository**: `BlogRepository.getBlogPostById(int)`
- **Description**: Récupérer un article par son ID
- **Paramètres**: `int` (id de l'article)
- **Retour**: `DataState<BlogPost>`

### 3. CreateBlogPostUseCase ✨ (nouveau)
- **Fichier**: `features/blog/domain/usecases/create_blog_post_usecase.dart`
- **Méthode repository**: `BlogRepository.createBlogPost(BlogPost)`
- **Description**: Créer un nouvel article de blog
- **Paramètres**: `BlogPost` (nouveau article)
- **Retour**: `DataState<BlogPost>`

### 4. UpdateBlogPostUseCase ✨ (nouveau)
- **Fichier**: `features/blog/domain/usecases/update_blog_post_usecase.dart`
- **Méthode repository**: `BlogRepository.updateBlogPost(BlogPost)`
- **Description**: Mettre à jour un article existant
- **Paramètres**: `BlogPost` (article modifié)
- **Retour**: `DataState<BlogPost>`

### 5. DeleteBlogPostUseCase ✨ (nouveau)
- **Fichier**: `features/blog/domain/usecases/delete_blog_post_usecase.dart`
- **Méthode repository**: `BlogRepository.deleteBlogPost(int)`
- **Description**: Supprimer un article de blog
- **Paramètres**: `DeleteBlogPostParams` (avec id)
- **Retour**: `DataState<void>`

### 6. SearchBlogPostsUseCase ✨ (nouveau)
- **Fichier**: `features/blog/domain/usecases/search_blog_posts_usecase.dart`
- **Méthode repository**: `BlogRepository.searchBlogPosts(String)`
- **Description**: Rechercher des articles par mot-clé
- **Paramètres**: `SearchBlogPostsParams` (avec query)
- **Retour**: `DataState<List<BlogPost>>`

## 🔧 Configuration

Tous les Use Cases sont enregistrés dans le service locator (`injection_container.dart`) et peuvent être injectés dans les Blocs ou autres composants.

### Utilisation dans un Bloc

```dart
class MyBloc extends Bloc<MyEvent, MyState> {
  final CreateBlogPostUseCase createBlogPost;
  final DeleteBlogPostUseCase deleteBlogPost;
  
  MyBloc({
    required this.createBlogPost,
    required this.deleteBlogPost,
  });
  
  // Dans un event handler
  Future<void> _onCreatePost(CreatePostEvent event, Emitter<MyState> emit) async {
    final result = await createBlogPost(event.blogPost);
    result.fold(
      (failure) => emit(ErrorState(failure)),
      (success) => emit(SuccessState(success)),
    );
  }
}
```

## ✅ Avantages

- **Séparation des responsabilités**: Chaque use case a une responsabilité unique
- **Testabilité**: Facile de mocker et tester chaque use case individuellement  
- **Réutilisabilité**: Les use cases peuvent être utilisés dans différents composants
- **Cohérence**: Pattern uniforme pour toutes les opérations métier
- **Clean Architecture**: Respect des principes SOLID et de l'architecture hexagonale
