/// Base exception class for MidJourney API related errors
/// MidJourney API 相关错误的基础异常类
class MidjourneyException implements Exception {
  /// Error message
  /// 错误信息
  final String message;

  /// Raw response from the API (optional)
  /// API 的原始响应（可选）
  final String? rawResponse;

  /// Step where the error occurred (optional)
  /// 发生错误的步骤（可选）
  final String? step;

  /// Creates a new MidjourneyException
  /// 创建一个新的 MidjourneyException
  MidjourneyException(
    this.message, {
    this.rawResponse,
    this.step,
  });

  @override
  String toString() {
    final buffer = StringBuffer('MidJourney Error');
    
    if (step != null) {
      buffer.write(' in step: $step');
    }
    
    buffer.write(': $message');
    
    if (rawResponse != null) {
      buffer.write('\nRaw response: $rawResponse');
    }
    
    return buffer.toString();
  }
}

/// Exception thrown when API requests fail
/// API 请求失败时抛出的异常
class MidjourneyApiException extends MidjourneyException {
  /// Creates a new MidjourneyApiException
  /// 创建一个新的 MidjourneyApiException
  MidjourneyApiException(
    String message, {
    String? rawResponse,
    String? step,
  }) : super(
    message,
    rawResponse: rawResponse,
    step: step,
  );
}

/// Exception thrown when JSON parsing fails
/// JSON 解析失败时抛出的异常
class MidjourneyJsonException extends MidjourneyException {
  /// Creates a new MidjourneyJsonException
  /// 创建一个新的 MidjourneyJsonException
  MidjourneyJsonException(
    String message, {
    String? rawResponse,
    String? step,
  }) : super(
    message,
    rawResponse: rawResponse,
    step: step,
  );
}

/// Exception thrown when upscale operations fail
/// 图片放大操作失败时抛出的异常
class MidjourneyUpscaleException extends MidjourneyException {
  /// Creates a new MidjourneyUpscaleException
  /// 创建一个新的 MidjourneyUpscaleException
  MidjourneyUpscaleException(
    String message, {
    String? rawResponse,
    String? step,
  }) : super(
    message,
    rawResponse: rawResponse,
    step: step,
  );
} 