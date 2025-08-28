import '../models/blog_post_model.dart';
import 'blog_remote_data_source.dart';

/// Fake implementation of BlogRemoteDataSource that uses simulated data
class BlogRemoteDataSourceFake implements BlogRemoteDataSource {
  // Fake blog posts database for simulation
  static final List<Map<String, dynamic>> _fakeBlogPosts = [
    {
      'id': 1,
      'title': 'Getting Started with Flutter',
      'content': '''
Flutter is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.

## Why Flutter?

Flutter offers several advantages:
- **Fast Development**: Hot reload helps you quickly and easily experiment, build UIs, add features, and fix bugs faster.
- **Expressive and Flexible UI**: Quickly ship features with a focus on native end-user experiences.
- **Native Performance**: Flutter's widgets incorporate all critical platform differences such as scrolling, navigation, icons and fonts.

## Getting Started

To get started with Flutter, you'll need to install the Flutter SDK and set up your development environment. Visit the official Flutter documentation for detailed installation instructions.

## Your First App

Creating your first Flutter app is as simple as running `flutter create my_app` in your terminal. This will generate a new Flutter project with a sample counter app.

Happy coding with Flutter! 🚀
      ''',
      'author': 'John Doe',
      'tags': ['flutter', 'mobile', 'development', 'tutorial'],
      'createdAt': '2024-08-20T10:30:00Z',
      'updatedAt': '2024-08-20T10:30:00Z',
    },
    {
      'id': 2,
      'title': 'Understanding State Management in Flutter',
      'content': '''
State management is one of the most important concepts in Flutter development. It determines how your app's data flows and how the UI responds to changes.

## Types of State

In Flutter, we have two main types of state:

### 1. Ephemeral State
This is the state you can neatly contain in a single widget. Examples include:
- Current page in a PageView
- Current progress of a complex animation
- Current selected tab in a BottomNavigationBar

### 2. App State
This is state that you want to share across many parts of your app, and that you want to keep between user sessions. Examples include:
- User preferences
- Login info
- Notifications in a social networking app
- The shopping cart in an e-commerce app

## Popular State Management Solutions

1. **Provider**: Recommended by the Flutter team
2. **Riverpod**: Modern evolution of Provider
3. **Bloc**: Business Logic Component pattern
4. **GetX**: Lightweight and powerful solution
5. **MobX**: Reactive state management

## Best Practices

- Keep state as local as possible
- Use StatefulWidget for simple, local state
- Consider app-wide state management for complex apps
- Don't over-engineer simple apps

Choose the right state management solution based on your app's complexity and team preferences.
      ''',
      'author': 'Jane Smith',
      'tags': ['flutter', 'state-management', 'architecture', 'best-practices'],
      'createdAt': '2024-08-22T14:15:00Z',
      'updatedAt': '2024-08-25T16:20:00Z',
    },
    {
      'id': 3,
      'title': 'Building Responsive UIs with Flutter',
      'content': '''
Creating responsive user interfaces is crucial for modern app development. Your app should look great on phones, tablets, and desktop devices.

## Responsive Design Principles

### 1. Flexible Layouts
Use flexible widgets like `Expanded`, `Flexible`, and `Wrap` to create layouts that adapt to different screen sizes.

### 2. Breakpoints
Define breakpoints for different screen sizes:
- Mobile: < 600px
- Tablet: 600px - 1200px
- Desktop: > 1200px

### 3. Adaptive Widgets
Flutter provides several widgets that automatically adapt to the platform:
- `LayoutBuilder`
- `MediaQuery`
- `OrientationBuilder`
- `AspectRatio`

## Code Example

```dart
class ResponsiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return MobileLayout();
        } else if (constraints.maxWidth < 1200) {
          return TabletLayout();
        } else {
          return DesktopLayout();
        }
      },
    );
  }
}
```

## Testing Responsive Designs

Always test your responsive designs on:
- Different device sizes
- Different orientations
- Various screen densities
- Web browsers with different window sizes

Remember: A truly responsive app feels native on every platform it runs on.
      ''',
      'author': 'Saliou Seck',
      'tags': ['flutter', 'responsive', 'ui-ux', 'layout', 'design'],
      'createdAt': '2024-08-24T09:45:00Z',
      'updatedAt': '2024-08-26T11:30:00Z',
    },
    {
      'id': 4,
      'title': 'Flutter Performance Optimization Tips',
      'content': '''
Performance is key to providing a great user experience. Here are essential tips to optimize your Flutter app's performance.

## Widget Building Optimization

### 1. Use const Constructors
Always use `const` constructors when possible to avoid unnecessary widget rebuilds:

```dart
const Text('Hello World') // Good
Text('Hello World')       // Not optimal
```

### 2. Minimize Widget Rebuilds
- Use `const` widgets wherever possible
- Implement proper `shouldRebuild` logic
- Use `Builder` widgets to limit rebuild scope

### 3. ListView Optimization
For long lists, always use `ListView.builder()` instead of `ListView()` with children.

## Image Optimization

### 1. Use Appropriate Image Formats
- WebP for web
- PNG for transparency
- JPEG for photos
- SVG for vector graphics

### 2. Image Caching
Implement proper image caching strategies:
- Use `CachedNetworkImage` for network images
- Preload critical images
- Optimize image sizes for different screen densities

## Memory Management

### 1. Dispose Resources
Always dispose of controllers, streams, and other resources:

```dart
@override
void dispose() {
  _controller.dispose();
  _subscription.cancel();
  super.dispose();
}
```

### 2. Use Object Pooling
For frequently created/destroyed objects, consider object pooling.

## Measuring Performance

Use Flutter's built-in tools:
- Flutter Inspector
- Performance Overlay
- Timeline View
- Memory View

## Key Metrics to Monitor

- Frame rendering time (aim for 16ms)
- Memory usage
- CPU usage
- GPU usage
- Network requests

Remember: Profile your app regularly and optimize based on real performance data, not assumptions.
      ''',
      'author': 'John Doe',
      'tags': [
        'flutter',
        'performance',
        'optimization',
        'best-practices',
        'profiling',
      ],
      'createdAt': '2024-08-25T13:20:00Z',
      'updatedAt': '2024-08-27T08:15:00Z',
    },
    {
      'id': 5,
      'title': 'Testing in Flutter: A Comprehensive Guide',
      'content': '''
Testing is an essential part of app development. Flutter provides excellent testing tools and frameworks to ensure your app works correctly.

## Types of Tests in Flutter

### 1. Unit Tests
Test individual functions, methods, and classes:

```dart
test('should add two numbers correctly', () {
  final calculator = Calculator();
  final result = calculator.add(2, 3);
  expect(result, 5);
});
```

### 2. Widget Tests
Test individual widgets and their interactions:

```dart
testWidgets('should display counter value', (WidgetTester tester) async {
  await tester.pumpWidget(CounterApp());
  expect(find.text('0'), findsOneWidget);
  
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  
  expect(find.text('1'), findsOneWidget);
});
```

### 3. Integration Tests
Test complete app flows:

```dart
void main() {
  group('App Test', () {
    testWidgets('complete user flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Simulate user interactions
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      
      // Verify results
      expect(find.text('Welcome'), findsOneWidget);
    });
  });
}
```

## Testing Best Practices

### 1. Test Pyramid
- Many unit tests (fast, isolated)
- Some widget tests (medium complexity)
- Few integration tests (slow, comprehensive)

### 2. Test Organization
- Group related tests
- Use descriptive test names
- Keep tests independent
- Use setup and teardown methods

### 3. Mocking and Stubbing
Use packages like `mockito` or `mocktail` for mocking dependencies:

```dart
class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;
  
  setUp(() {
    mockApiService = MockApiService();
  });
  
  test('should return user data', () async {
    when(() => mockApiService.getUser(any()))
        .thenAnswer((_) async => User(id: 1, name: 'John'));
    
    final repository = UserRepository(mockApiService);
    final user = await repository.getUser(1);
    
    expect(user.name, 'John');
  });
}
```

## Continuous Integration

Set up CI/CD pipelines to:
- Run tests automatically
- Check code coverage
- Ensure code quality
- Deploy tested builds

## Tools and Resources

- **flutter_test**: Built-in testing framework
- **mockito/mocktail**: Mocking libraries
- **integration_test**: Integration testing
- **golden_toolkit**: Golden file testing
- **patrol**: Advanced integration testing

Remember: Good tests give you confidence to refactor and add features without breaking existing functionality.
      ''',
      'author': 'Jane Smith',
      'tags': [
        'flutter',
        'testing',
        'quality-assurance',
        'automation',
        'best-practices',
      ],
      'createdAt': '2024-08-26T16:00:00Z',
      'updatedAt': '2024-08-27T09:45:00Z',
    },
  ];

  @override
  Future<List<BlogPostModel>> getAllBlogPosts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    return _fakeBlogPosts.map((json) => BlogPostModel.fromJson(json)).toList();
  }

  @override
  Future<BlogPostModel> getBlogPostById(int id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    final blogPostData = _fakeBlogPosts.firstWhere(
      (post) => post['id'] == id,
      orElse: () => throw Exception('Blog post with id $id not found'),
    );

    return BlogPostModel.fromJson(blogPostData);
  }

  @override
  Future<BlogPostModel> createBlogPost(BlogPostModel blogPost) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Generate new ID
    final newId = _fakeBlogPosts.isEmpty
        ? 1
        : _fakeBlogPosts
                  .map((p) => p['id'] as int)
                  .reduce((a, b) => a > b ? a : b) +
              1;

    final now = DateTime.now().toIso8601String();
    final newBlogPostData = {
      'id': newId,
      'title': blogPost.title,
      'content': blogPost.content,
      'author': blogPost.author,
      'tags': blogPost.tags,
      'createdAt': now,
      'updatedAt': now,
    };

    // Add to fake database
    _fakeBlogPosts.add(newBlogPostData);

    return BlogPostModel.fromJson(newBlogPostData);
  }

  @override
  Future<BlogPostModel> updateBlogPost(BlogPostModel blogPost) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 700));

    final index = _fakeBlogPosts.indexWhere(
      (post) => post['id'] == blogPost.id,
    );
    if (index == -1) {
      throw Exception('Blog post with id ${blogPost.id} not found');
    }

    // Update the blog post
    final updatedBlogPostData = {
      ..._fakeBlogPosts[index],
      'title': blogPost.title,
      'content': blogPost.content,
      'author': blogPost.author,
      'tags': blogPost.tags,
      'updatedAt': DateTime.now().toIso8601String(),
    };

    _fakeBlogPosts[index] = updatedBlogPostData;

    return BlogPostModel.fromJson(updatedBlogPostData);
  }

  @override
  Future<void> deleteBlogPost(int id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _fakeBlogPosts.indexWhere((post) => post['id'] == id);
    if (index == -1) {
      throw Exception('Blog post with id $id not found');
    }

    // Remove from fake database
    _fakeBlogPosts.removeAt(index);
  }

  @override
  Future<List<BlogPostModel>> searchBlogPosts(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 450));

    if (query.isEmpty) {
      return getAllBlogPosts();
    }

    final lowercaseQuery = query.toLowerCase();
    final filteredPosts = _fakeBlogPosts.where((post) {
      final title = (post['title'] as String).toLowerCase();
      final content = (post['content'] as String).toLowerCase();
      final author = (post['author'] as String).toLowerCase();
      final tags = (post['tags'] as List<dynamic>)
          .map((tag) => tag.toString().toLowerCase())
          .toList();

      return title.contains(lowercaseQuery) ||
          content.contains(lowercaseQuery) ||
          author.contains(lowercaseQuery) ||
          tags.any((tag) => tag.contains(lowercaseQuery));
    }).toList();

    return filteredPosts.map((json) => BlogPostModel.fromJson(json)).toList();
  }
}
