import 'dart:math';

import 'package:aap_ka_dost/models/coin.dart';
import 'package:aap_ka_dost/services/crypto_service.dart';
import 'package:aap_ka_dost/widgets/animated_line_chart.dart';
import 'package:flutter/material.dart';

class CoinDetailScreen extends StatefulWidget {
  final String coinId; // e.g., 'bitcoin'
  const CoinDetailScreen({super.key, required this.coinId});

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  late Future<Coin> _futureCoin;

  @override
  void initState() {
    super.initState();
    _futureCoin = CryptoService.instance.fetchCoin(widget.coinId);
  }

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            flexibleSpace: Container(decoration: BoxDecoration(gradient: gradient)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: const Text('CryptoPulse'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () {
                  setState(() {
                    _futureCoin = CryptoService.instance.fetchCoin(widget.coinId);
                  });
                },
              ),
            ],
          ),
          body: FutureBuilder<Coin>(
            future: _futureCoin,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final coin = snapshot.data!;
              return _Content(coin: coin);
            },
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final Coin coin;
  const _Content({required this.coin});

  @override
  Widget build(BuildContext context) {
    final Color accent = coin.isRising ? const Color(0xFF00C853) : const Color(0xFFD50000);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, -4)),
              ],
            ),
            child: Row(
              children: [
                _CoinAvatar(icon: coin.icon),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coin.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        coin.symbol,
                        style: TextStyle(color: Colors.grey.shade600, letterSpacing: 1.2),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatCurrency(coin.currentPrice),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(coin.isRising ? Icons.trending_up : Icons.trending_down,
                              size: 16, color: accent),
                          const SizedBox(width: 6),
                          Text(
                            '${coin.changePercent24h.toStringAsFixed(2)}%',
                            style: TextStyle(color: accent, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Chart Card
          _GlassCard(
            child: SizedBox(
              height: 220,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: AnimatedLineChart(points: coin.priceHistory24h, isRising: coin.isRising),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Stats Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              runSpacing: 12,
              spacing: 12,
              children: [
                _StatTile(icon: Icons.arrow_upward_rounded, label: '24h High', value: _formatCompact(coin.stats.high24h)),
                _StatTile(icon: Icons.arrow_downward_rounded, label: '24h Low', value: _formatCompact(coin.stats.low24h)),
                _StatTile(icon: Icons.pie_chart_rounded, label: 'Market Cap', value: _formatCompact(coin.stats.marketCap)),
                _StatTile(icon: Icons.swap_vert_rounded, label: 'Volume (24h)', value: _formatCompact(coin.stats.volume24h)),
                _StatTile(icon: Icons.token_rounded, label: 'Circulating Supply', value: _formatCompact(coin.stats.circulatingSupply)),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Investment Insights (Optional)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Investment Insights',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: SizedBox(
                              height: 8,
                              child: LinearProgressIndicator(
                                value: min(1, (coin.changePercent24h.abs() / 10)),
                                backgroundColor: accent.withOpacity(0.15),
                                valueColor: AlwaysStoppedAnimation<Color?>(accent),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          coin.isRising ? 'Bullish' : 'Bearish',
                          style: TextStyle(color: accent, fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      coin.isRising
                          ? 'Price trend is positive over the last 24h.'
                          : 'Price trend is negative over the last 24h.',
                      style: TextStyle(color: Colors.grey.shade700),
                    )
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    return '\$' + value.toStringAsFixed(value >= 100 ? 0 : 2);
  }

  String _formatCompact(double n) {
    const suffixes = ['', 'K', 'M', 'B', 'T'];
    int i = 0;
    double v = n.abs();
    while (v >= 1000 && i < suffixes.length - 1) {
      v /= 1000;
      i++;
    }
    String sign = n < 0 ? '-' : '';
    return '$sign${v.toStringAsFixed(v >= 100 ? 0 : 2)}${suffixes[i]}';
  }
}

class _CoinAvatar extends StatelessWidget {
  final IconData? icon;
  const _CoinAvatar({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF64B5F6), Color(0xFF82B1FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Icon(icon ?? Icons.currency_bitcoin, color: Colors.white),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.8),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 6))],
        border: Border.all(color: const Color(0x11000000)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: child,
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final double width = (MediaQuery.of(context).size.width - (16 * 2) - 12) / 2;
    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 4))],
        border: Border.all(color: const Color(0x11000000)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
