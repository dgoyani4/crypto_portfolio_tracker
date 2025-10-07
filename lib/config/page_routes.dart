enum PageRoutes {
  splash(name: 'Splash Screen'),
  home(name: 'Home Screen'),
  addCoin(name: 'Add Coin Screen');

  final String name;
  const PageRoutes({required this.name});
}
