import 'dart:convert';
import 'dart:io';
import 'package:flexy_markets/constant/user_constant.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  static const String _baseUrl = 'wss://backend.boostbullion.com';

  WebSocketChannel? _channel;
  bool _isConnected = false;

  // Event callbacks
  Function(Map<String, dynamic>)? onPaymentReady;
  Function(Map<String, dynamic>)? onPaymentStatus;
  Function(String)? onError;
  Function()? onDisconnected;

  bool get isConnected => _isConnected;

  Future<void> connect() async {
    try {
      _channel = IOWebSocketChannel.connect(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization':UserConstants.TOKEN,
        },
      );

      _isConnected = true;

      // Listen to incoming messages
      _channel!.stream.listen(
            (message) {
          _handleMessage(message);
        },
        onError: (error) {
          print('WebSocket Error: $error');
          _isConnected = false;
          onError?.call(error.toString());
        },
        onDone: () {
          print('WebSocket connection closed');
          _isConnected = false;
          onDisconnected?.call();
        },
      );

      print('WebSocket connected successfully');
    } catch (e) {
      print('Failed to connect WebSocket: $e');
      _isConnected = false;
      onError?.call('Failed to connect: $e');
    }
  }

  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      final event = data['event'] ?? data['type'];

      switch (event) {
        case 'paymentReady':
          onPaymentReady?.call(data);
          break;
        case 'paymentStatus':
          onPaymentStatus?.call(data);
          break;
        default:
          print('Unknown event: $event');
      }
    } catch (e) {
      print('Error parsing message: $e');
      onError?.call('Error parsing message: $e');
    }
  }

  void startPayment({
    required String network,
    required double amount,
  }) {
    if (!_isConnected || _channel == null) {
      onError?.call('WebSocket not connected');
      return;
    }

    final paymentData = {
      'event': 'startPayment',
      'data': {
        'network': network,
        'amount': amount,
      }
    };

    try {
      _channel!.sink.add(jsonEncode(paymentData));
      print('Payment started: $paymentData');
    } catch (e) {
      print('Error sending payment data: $e');
      onError?.call('Error sending payment data: $e');
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
    print('WebSocket disconnected');
  }
}

// Payment models
class PaymentInfo {
  final String paymentAddress;
  final String tokenSymbol;
  final String blockchain;
  final String tokenName;
  final String logoUrl;
  final int tokenDecimals;
  final String receiveAmount;
  final String receiveCurrency;
  final String exchangeRate;
  final String assetLogo;

  PaymentInfo({
    required this.paymentAddress,
    required this.tokenSymbol,
    required this.blockchain,
    required this.tokenName,
    required this.logoUrl,
    required this.tokenDecimals,
    required this.receiveAmount,
    required this.receiveCurrency,
    required this.exchangeRate,
    required this.assetLogo,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      paymentAddress: json['payment_address'] ?? '',
      tokenSymbol: json['token_symbol'] ?? '',
      blockchain: json['blockchain'] ?? '',
      tokenName: json['token_name'] ?? '',
      logoUrl: json['logo_url'] ?? '',
      tokenDecimals: json['token_decimals'] ?? 18,
      receiveAmount: json['receive_amount'] ?? '',
      receiveCurrency: json['receive_currency'] ?? '',
      exchangeRate: json['exchange_rate'] ?? '',
      assetLogo: json['asset_logo'] ?? '',
    );
  }
}

class PaymentData {
  final String cregisId;
  final String checkoutUrl;
  final String? merchantName;
  final String? merchantLogoUrl;
  final String orderAmount;
  final String orderCurrency;
  final int createdTime;
  final int expireTime;
  final List<PaymentInfo> paymentInfo;

  PaymentData({
    required this.cregisId,
    required this.checkoutUrl,
    this.merchantName,
    this.merchantLogoUrl,
    required this.orderAmount,
    required this.orderCurrency,
    required this.createdTime,
    required this.expireTime,
    required this.paymentInfo,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      cregisId: json['cregis_id'] ?? '',
      checkoutUrl: json['checkout_url'] ?? '',
      merchantName: json['merchant_name'],
      merchantLogoUrl: json['merchant_logo_url'],
      orderAmount: json['order_amount'] ?? '',
      orderCurrency: json['order_currency'] ?? '',
      createdTime: json['created_time'] ?? 0,
      expireTime: json['expire_time'] ?? 0,
      paymentInfo: (json['payment_info'] as List<dynamic>?)
          ?.map((item) => PaymentInfo.fromJson(item))
          .toList() ?? [],
    );
  }
}