enum Environment {
  development,
  staging,
  production;

  static Environment fromName(String name) {
    switch (name.trim().toLowerCase()) {
      case 'prod':
      case 'production':
        return Environment.production;
      case 'stage':
      case 'staging':
        return Environment.staging;
      case 'dev':
      case 'development':
      default:
        return Environment.development;
    }
  }
}
