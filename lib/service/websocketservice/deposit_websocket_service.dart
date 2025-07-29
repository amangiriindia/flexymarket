import 'dart:convert';
import 'package:flexy_markets/constant/user_constant.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketService {
  static const String _baseUrl = 'wss://backend.boostbullion.com';
  IO.Socket? _socket;
  bool _isConnected = false;

  // Event callbacks
  Function(Map<String, dynamic>)? onPaymentReady;
  Function(Map<String, dynamic>)? onPaymentStatus;
  Function(String)? onError;
  Function()? onDisconnected;
  Function()? onConnected; // Added connection callback

  bool get isConnected => _isConnected;

  Future<void> connect() async {
    try {
      // Validate token
      if (UserConstants.TOKEN!.isEmpty) {
        throw Exception('Authorization token is missing');
      }

      // Decode JWT to check expiration
      final jwtParts = UserConstants.TOKEN!.split('.');
      if (jwtParts.length != 3) {
        throw Exception('Invalid JWT format');
      }
      final payload = jsonDecode(
          String.fromCharCodes(base64Url.decode(base64Url.normalize(jwtParts[1]))));
      final exp = payload['exp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (exp < now) {
        throw Exception('Token expired');
      }

      _socket = IO.io(
        _baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setPath('/socket.io')
            .setExtraHeaders({'Authorization': UserConstants.TOKEN})
            .setQuery({'v': '3'})
            .build(),
      );

      // Set up ALL event listeners BEFORE connecting
      _socket!.onConnect((_) {
        _isConnected = true;
        print('WebSocket connected successfully');
        onConnected?.call(); // Notify connection established
      });

      _socket!.on('paymentReady', (data) {
        print('Received paymentReady event: $data');
        try {
          final paymentData = data is Map<String, dynamic>
              ? data
              : Map<String, dynamic>.from(data);
          onPaymentReady?.call(paymentData);
        } catch (e) {
          print('Error processing paymentReady data: $e');
          onError?.call('Error processing paymentReady: $e');
        }
      });

      _socket!.on('paymentStatus', (data) {
        print('Received paymentStatus event: $data');
        try {
          final statusData = data is Map<String, dynamic>
              ? data
              : Map<String, dynamic>.from(data);
          onPaymentStatus?.call(statusData);
        } catch (e) {
          print('Error processing paymentStatus data: $e');
          onError?.call('Error processing paymentStatus: $e');
        }
      });

      _socket!.onError((error) {
        print('WebSocket Error: $error');
        _isConnected = false;
        onError?.call(error.toString());
      });

      _socket!.onDisconnect((reason) {
        print('WebSocket connection closed: $reason');
        _isConnected = false;
        onDisconnected?.call();
      });

      // Add connection timeout handling
      _socket!.onConnectError((error) {
        print('WebSocket Connection Error: $error');
        _isConnected = false;
        onError?.call('Connection failed: $error');
      });

      // Now connect after all listeners are set up
      _socket!.connect();

    } catch (e) {
      print('Failed to connect WebSocket: $e');
      _isConnected = false;
      onError?.call('Failed to connect: $e');
    }
  }

  void startPayment({
    required String network,
    required double amount,
  }) {
    if (!_isConnected || _socket == null) {
      print('WebSocket not connected - cannot start payment');
      onError?.call('WebSocket not connected');
      return;
    }

    final paymentData = {
      'network': network,
      'amount': amount,
    };

    try {
      _socket!.emit('startPayment', paymentData);
      print('Payment started: $paymentData');
    } catch (e) {
      print('Error sending payment data: $e');
      onError?.call('Error sending payment data: $e');
    }
  }

  // Method to check connection status and reconnect if needed
  Future<void> ensureConnection() async {
    if (!_isConnected || _socket == null) {
      print('Connection lost, attempting to reconnect...');
      await connect();
    }
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
    _isConnected = false;
    print('WebSocket disconnected');
  }
}

// Usage example class
class PaymentService {
  final WebSocketService _webSocketService = WebSocketService();

  Future<void> initializePayment() async {
    // Set up event handlers BEFORE connecting
    _webSocketService.onConnected = () {
      print('WebSocket connection established, ready for payments');
    };

    _webSocketService.onPaymentReady = (data) {
      print('Payment ready received: $data');
      // Handle payment ready data
      try {
        final paymentData = PaymentData.fromJson(data);
        // Process payment data
      } catch (e) {
        print('Error parsing payment data: $e');
      }
    };

    _webSocketService.onPaymentStatus = (data) {
      print('Payment status received: $data');
      // Handle payment status updates
    };

    _webSocketService.onError = (error) {
      print('WebSocket error: $error');
      // Handle errors, maybe show user notification
    };

    _webSocketService.onDisconnected = () {
      print('WebSocket disconnected');
      // Handle disconnection, maybe try to reconnect
    };

    // Now connect
    await _webSocketService.connect();
  }

  void makePayment(String network, double amount) {
    _webSocketService.startPayment(network: network, amount: amount);
  }

  void dispose() {
    _webSocketService.disconnect();
  }
}

// Payment models (unchanged)
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
          .toList() ??
          [],
    );
  }
}