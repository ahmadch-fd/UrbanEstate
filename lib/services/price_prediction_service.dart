import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class PricePredictionService {
  PricePredictionService._();

  static const _productionBaseUrl =
      'https://ahmadcodecraft-urban-estate-price-prediction.hf.space';

  static const _configuredBaseUrl = String.fromEnvironment(
    'PREDICTION_API_URL',
  );

  static Future<PricePrediction> predict(Map<String, dynamic> input) async {
    final url = _configuredBaseUrl.isNotEmpty
        ? _configuredBaseUrl
        : _productionBaseUrl;
    Object? lastError;

    try {
      final response = await http
          .post(
            Uri.parse('$url/predict'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(input),
          )
          .timeout(const Duration(seconds: 60));

      return _predictionFromResponse(response);
    } on TimeoutException catch (error) {
      lastError = error;
    } catch (error) {
      lastError = error;
    }

    throw PricePredictionException(
      'The online model API could not be reached. Check your internet '
      'connection and try again. Details: $lastError',
    );
  }

  static PricePrediction _predictionFromResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode != 200 || body is! Map<String, dynamic>) {
      throw PricePredictionException(
        'Prediction server returned ${response.statusCode}.',
      );
    }

    final predictedPrice = body['predicted_price_pkr'];
    if (predictedPrice is! num) {
      throw const PricePredictionException(
        'Prediction server returned an invalid price.',
      );
    }

    return PricePrediction(
      value: predictedPrice.toDouble(),
      formattedValue:
          body['formatted_price']?.toString() ??
          'Rs. ${predictedPrice.toStringAsFixed(0)}',
    );
  }
}

class PricePrediction {
  const PricePrediction({required this.value, required this.formattedValue});

  final double value;
  final String formattedValue;

  String get databaseValue => value.toStringAsFixed(2);
}

class PricePredictionException implements Exception {
  const PricePredictionException(this.message);

  final String message;

  @override
  String toString() => message;
}
