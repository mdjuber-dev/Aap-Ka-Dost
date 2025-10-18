import 'package:flutter/material.dart';

class PricePoint {
  final DateTime time;
  final double price;

  const PricePoint({required this.time, required this.price});
}

class MarketStats {
  final double high24h;
  final double low24h;
  final double marketCap;
  final double volume24h;
  final double circulatingSupply;

  const MarketStats({
    required this.high24h,
    required this.low24h,
    required this.marketCap,
    required this.volume24h,
    required this.circulatingSupply,
  });
}

class Coin {
  final String id;
  final String name;
  final String symbol;
  final IconData? icon;
  final double currentPrice;
  final double changePercent24h; // negative for loss
  final MarketStats stats;
  final List<PricePoint> priceHistory24h; // sorted ascending by time

  const Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.icon,
    required this.currentPrice,
    required this.changePercent24h,
    required this.stats,
    required this.priceHistory24h,
  });

  bool get isRising => changePercent24h >= 0;
}
