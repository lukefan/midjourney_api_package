# QianDuo MidJourney API Package

A Dart package that provides a simple and efficient way to interact with the MidJourney API. This package allows you to generate images, upscale them, and monitor task status through MidJourney's API service.

## API Provider

This package is powered by QianDuoDuo's MidJourney API service. Before using this package, you need to:

1. Register for an account at [api.ifopen.ai](https://api.ifopen.ai/register?aff=toNN)
2. Obtain your API token from the dashboard
3. Use the default base URL: `https://api.ifopen.ai`

## Features

- 🎨 Generate images using text prompts
- 🔍 Upscale generated images
- 📊 Monitor task status and progress
- 🔄 Automatic task polling
- 🛡️ Error handling and type safety
- 📝 Comprehensive logging

## Installation

Add this package to your project's `pubspec.yaml`:

```yaml
dependencies:
  qianduo_midjourney_api: ^1.0.0
```

Then run:

```bash
dart pub get
```

## Usage

### Initialize the API Client

```dart
final api = MidjourneyApi(
  baseUrl: 'https://api.ifopen.ai', // Default base URL
  apiToken: 'YOUR_API_TOKEN', // Get this from api.ifopen.ai dashboard
);
```

### Generate an Image

```dart
try {
  final response = await api.imagine('A beautiful sunset over mountains');
  print('Task ID: ${response.taskId}');
} catch (e) {
  print('Error generating image: $e');
}
```

### Monitor Task Status

```dart
final status = await api.pollTaskStatus(
  taskId,
  onProgress: (status, progress) {
    print('Status: $status, Progress: $progress');
  },
);
```

### Upscale an Image

```dart
try {
  // Get upscale buttons from task status
  final buttons = api.getUpscaleButtons(status);
  
  // Upscale the first image (U1)
  final upscaleResponse = await api.upscale(
    buttons[0]['taskId']!,
    buttons[0]['customId']!,
  );
  
  print('Upscale task ID: ${upscaleResponse.taskId}');
} catch (e) {
  print('Error upscaling image: $e');
}
```

### Get Image URL

```dart
final imageUrl = api.getImageUrl(taskId);
```

## Error Handling

The package includes comprehensive error handling with specific exception types:

- `MidjourneyApiException`: For API-related errors
- `MidjourneyJsonException`: For JSON parsing errors
- `MidjourneyUpscaleException`: For upscaling-related errors

Example error handling:

```dart
try {
  final response = await api.imagine('prompt');
} on MidjourneyApiException catch (e) {
  print('API Error: ${e.message}');
} on MidjourneyJsonException catch (e) {
  print('JSON Error: ${e.message}');
} catch (e) {
  print('Unexpected error: $e');
}
```

## Cleanup

Don't forget to dispose of the API client when you're done:

```dart
api.dispose();
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer

This package is not officially associated with MidJourney. Make sure you comply with MidJourney's terms of service and API usage guidelines when using this package. 