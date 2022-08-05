import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

class DotsIndicatorPage extends StatefulWidget {

  @override
  State<DotsIndicatorPage> createState() => _DotsIndicatorPageState();
}

class _DotsIndicatorPageState extends State<DotsIndicatorPage> {
  final carros = [
    'assets/images/carros/carro-1.jpg',
    'assets/images/carros/carro-2.jpg',
    'assets/images/carros/carro-3.jpg',
    'assets/images/carros/carro-4.jpg',
    'assets/images/carros/carro-5.jpg',
  ];

  var _currentIndex = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dots Indicator'),
      ),
      body: Stack(
        children: <Widget>[
          _pageview(),
          Align(
            alignment: Alignment.bottomCenter,
            child: dots_indicator(context),
          )
        ],
      ),
    );
  }

  _pageview() {
    return PageView.builder(
      itemCount: carros.length,
        itemBuilder: (context, idx) {
          String foto = carros[idx];

          return Image.asset(foto, fit: BoxFit.fitHeight);
        },
        onPageChanged: (idx) => onPageChanged(idx),
      );
  }

  dots_indicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DotsIndicator(
        dotsCount: carros.length,
        position: _currentIndex,
        decorator: DotsDecorator(
          color: Colors.white,
          activeColor: Colors.blue,
        ),
      ),
    );
  }

  onPageChanged(int value) {
    setState(() {
      var index = value.toDouble();
      this._currentIndex = index;
    });
  }
}
