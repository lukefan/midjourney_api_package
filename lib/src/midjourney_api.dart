import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/midjourney_models.dart';
import 'exceptions/midjourney_exceptions.dart';

/// MidJourney API Client
/// MidJourney API 客户端
class MidjourneyApi {
  /// HTTP client instance
  /// HTTP 客户端实例
  final http.Client _client = http.Client();
  
  /// Base URL for the API
  /// API 基础 URL
  final String baseUrl;
  
  /// API authentication token
  /// API 认证令牌
  final String apiToken;

  /// Constructor for MidjourneyApi
  /// MidjourneyApi 构造函数
  MidjourneyApi({
    required this.baseUrl,
    required this.apiToken,
  });

  /// Generate an image based on the provided prompt
  /// 根据提供的提示词生成图片
  Future<ImagineResponse> imagine(String prompt) async {
    try {
      print('Sending generation request, prompt: $prompt');
      final response = await _client.post(
        Uri.parse('$baseUrl/mj/submit/imagine'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
        body: jsonEncode({
          'prompt': prompt,
        }),
      );

      if (response.statusCode != 200) {
        print('API response error: ${response.statusCode}');
        print('Response content: ${response.body}');
        throw MidjourneyApiException(
          'API request failed: ${response.statusCode}',
          rawResponse: response.body,
          step: 'imagine',
        );
      }

      try {
        final jsonData = jsonDecode(response.body);
        print('Generation task response data: $jsonData');
        return ImagineResponse.fromJson(jsonData);
      } catch (e) {
        print('JSON parsing error: $e');
        print('Raw response: ${response.body}');
        throw MidjourneyJsonException(
          'JSON parsing failed: $e',
          rawResponse: response.body,
          step: 'imagine',
        );
      }
    } catch (e) {
      if (e is MidjourneyException) rethrow;
      print('Request exception: $e');
      throw MidjourneyApiException(
        'Request failed: $e',
        step: 'imagine',
      );
    }
  }

  /// Get the status of a specific task
  /// 获取特定任务的状态
  Future<TaskStatus> getTaskStatus(String taskId) async {
    try {
      print('Getting task status, task ID: $taskId');
      final response = await _client.get(
        Uri.parse('$baseUrl/mj/task/$taskId/fetch'),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      );

      if (response.statusCode != 200) {
        print('API response error: ${response.statusCode}');
        print('Response content: ${response.body}');
        throw MidjourneyApiException(
          'API request failed: ${response.statusCode}',
          rawResponse: response.body,
          step: 'getTaskStatus',
        );
      }

      try {
        final jsonData = jsonDecode(response.body);
        print('API response data: $jsonData');
        final status = TaskStatus.fromJson(jsonData);
        print('Parsed status object: $status');
        return status;
      } catch (e) {
        print('JSON parsing error: $e');
        print('Raw response: ${response.body}');
        throw MidjourneyJsonException(
          'JSON parsing failed: $e',
          rawResponse: response.body,
          step: 'getTaskStatus',
        );
      }
    } catch (e) {
      if (e is MidjourneyException) rethrow;
      print('Request exception: $e');
      throw MidjourneyApiException(
        'Request failed: $e',
        step: 'getTaskStatus',
      );
    }
  }

  /// Upscale a generated image
  /// 放大生成的图片
  Future<ImagineResponse> upscale(String taskId, String customId) async {
    try {
      print('Sending upscale request, task ID: $taskId, custom ID: $customId');
      final response = await _client.post(
        Uri.parse('$baseUrl/mj/submit/action'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
        body: jsonEncode({
          'taskId': taskId,
          'customId': customId,
        }),
      );

      if (response.statusCode != 200) {
        throw MidjourneyApiException(
          'API request failed: ${response.statusCode}',
          rawResponse: response.body,
          step: 'upscale',
        );
      }

      try {
        return ImagineResponse.fromJson(jsonDecode(response.body));
      } catch (e) {
        throw MidjourneyJsonException(
          'JSON parsing failed: $e',
          rawResponse: response.body,
          step: 'upscale',
        );
      }
    } catch (e) {
      if (e is MidjourneyException) rethrow;
      throw MidjourneyApiException(
        'Request failed: $e',
        step: 'upscale',
      );
    }
  }

  /// Get the URL for a generated image
  /// 获取生成图片的 URL
  String getImageUrl(String taskId) {
    return '$baseUrl/mj/image/$taskId';
  }

  /// Get upscale button information from task status
  /// 从任务状态中获取放大按钮信息
  List<Map<String, String>> getUpscaleButtons(TaskStatus status) {
    if (status.buttons == null) {
      throw MidjourneyUpscaleException(
        'Task not completed, cannot get upscale buttons',
        step: 'getUpscaleButtons',
      );
    }

    final List<Map<String, String>> buttons = [];
    
    // Search for U1-U4 buttons in order
    // 按顺序查找 U1-U4 按钮
    for (int i = 1; i <= 4; i++) {
      final button = status.buttons!.firstWhere(
        (btn) => btn.label == 'U$i',
        orElse: () => throw MidjourneyUpscaleException(
          'Cannot find U$i button',
          step: 'getUpscaleButtons',
        ),
      );
      
      buttons.add({
        'taskId': status.id,
        'customId': button.customId,
      });
    }
    
    return buttons;
  }

  /// Poll task status until completion
  /// 轮询任务状态直到完成
  Future<TaskStatus> pollTaskStatus(
    String taskId, {
    Duration interval = const Duration(seconds: 2),
    void Function(String status, String progress)? onProgress,
  }) async {
    while (true) {
      final status = await getTaskStatus(taskId);
      
      if (status.status == 'SUCCESS') {
        onProgress?.call(status.status, status.progress);
        return status;
      } else if (status.status == 'FAILED') {
        throw MidjourneyUpscaleException(
          'Task failed: ${status.failReason}',
          step: 'pollTaskStatus',
        );
      }
      
      onProgress?.call(status.status, status.progress);
      await Future.delayed(interval);
    }
  }

  /// Close the client and release resources
  /// 关闭客户端并释放资源
  void dispose() {
    _client.close();
  }
} 