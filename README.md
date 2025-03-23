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
  qianduo_midjourney_api: ^1.0.2
```

Then run:

```bash
dart pub get
```

## Usage

### Complete Example

Here's a complete example of how to generate an image, monitor its progress, get the image URL, and upscale it:

```dart
void main() async {
  final api = MidjourneyApi(
    baseUrl: 'https://api.ifopen.ai',
    apiToken: 'YOUR_API_TOKEN',
  );

  try {
    // 1. Generate image
    final response = await api.imagine('A beautiful sunset over mountains');
    final taskId = response.result.toString();
    print('Generation started, task ID: $taskId');

    // 2. Monitor progress until completion
    final status = await api.pollTaskStatus(
      taskId,
      onProgress: (status, progress) {
        print('Status: $status, Progress: $progress');
      },
    );

    // 3. Get image URL when status is SUCCESS
    if (status.status == 'SUCCESS') {
      final imageUrl = api.getImageUrl(status.id);
      print('Image URL: $imageUrl');

      // 4. Get upscale buttons
      final buttons = api.getUpscaleButtons(status);
      print('Available upscale buttons:');
      for (var i = 0; i < buttons.length; i++) {
        print('U${i + 1}: taskId=${buttons[i]['taskId']}, customId=${buttons[i]['customId']}');
      }

      // 5. Upscale a specific version (e.g., U1)
      final upscaleResponse = await api.upscale(
        buttons[0]['taskId']!,
        buttons[0]['customId']!,
      );
      final upscaleTaskId = upscaleResponse.result.toString();

      // 6. Monitor upscale progress
      final upscaleStatus = await api.pollTaskStatus(
        upscaleTaskId,
        onProgress: (status, progress) {
          print('Upscale Status: $status, Progress: $progress');
        },
      );

      // 7. Get upscaled image URL
      if (upscaleStatus.status == 'SUCCESS') {
        final upscaledImageUrl = api.getImageUrl(upscaleStatus.id);
        print('Upscaled Image URL: $upscaledImageUrl');
      }
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    api.dispose();
  }
}
```

### Step-by-Step Guide

1. Initialize the API Client:
```dart
final api = MidjourneyApi(
  baseUrl: 'https://api.ifopen.ai',
  apiToken: 'YOUR_API_TOKEN',
);
```

2. Generate an Image:
```dart
final response = await api.imagine('Your prompt here');
final taskId = response.result.toString();
```

3. Monitor Task Status:
```dart
final status = await api.pollTaskStatus(
  taskId,
  onProgress: (status, progress) {
    print('Status: $status, Progress: $progress');
  },
);
```

4. Get Image URL:
```dart
if (status.status == 'SUCCESS') {
  final imageUrl = api.getImageUrl(status.id);
}
```

5. Get Upscale Buttons:
```dart
final buttons = api.getUpscaleButtons(status);
// buttons is a list of maps containing taskId and customId for each U1-U4 button
// Example: [{'taskId': 'xxx', 'customId': 'yyy'}, ...]
```

6. Upscale an Image:
```dart
// Upscale using U1 button (first button)
final upscaleResponse = await api.upscale(
  buttons[0]['taskId']!,
  buttons[0]['customId']!,
);
```

7. Clean up:
```dart
api.dispose();
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

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer

This package is not officially associated with MidJourney. Make sure you comply with MidJourney's terms of service and API usage guidelines when using this package. 