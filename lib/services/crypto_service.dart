import 'dart:math';

import 'package:aap_ka_dost/models/coin.dart';
import 'package:flutter/material.dart';

/// Mock service emulating a CoinGecko-like API.
class CryptoService {
  CryptoService._();
  static final instance = CryptoService._();

  /// Returns a mock Bitcoin coin with 24h price history and stats.
  Future<Coin> fetchCoin(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockBitcoin();
  }

  Coin _mockBitcoin() {
    final now = DateTime.now();
    final List<PricePoint> points = [];
    final int steps = 60; // per 24h simplified
    double base = 68000; // starting price
    final Random rng = Random(42);
    for (int i = 0; i < steps; i++) {
      final t = now.subtract(Duration(minutes: (steps - i) * 24));
      base += rng.nextDouble() * 200 - 100; // random walk
      points.add(PricePoint(time: t, price: base));
    }

    final double minP = points.map((e) => e.price).reduce(min);
    final double maxP = points.map((e) => e.price).reduce(max);
    final double current = points.last.price;
    final double open = points.first.price;
    final double changePct = ((current - open) / open) * 100;

    return Coin(
      id: 'bitcoin',
      name: 'Bitcoin',
      symbol: 'BTC',
      icon: Icons.currency_bitcoin,
      currentPrice: current,
      changePercent24h: changePct,
      stats: MarketStats(
        high24h: maxP,
        low24h: minP,
        marketCap: 1.34e12,
        volume24h: 3.2e10,
        circulatingSupply: 19.7e6,
      ),
      priceHistory24h: points,
    );
  }
}
