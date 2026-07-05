import 'environment.dart';

class AppConfig {
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
  });

  factory AppConfig.fromEnvironment() {
    const environmentName = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'dev',
    );

    const apiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:8000',
    );

    return AppConfig(
      environment: Environment.fromName(environmentName),
      apiBaseUrl: apiBaseUrl,
    );
  }

  final Environment environment;
  final String apiBaseUrl;
}

final appConfig = AppConfig.fromEnvironment();
