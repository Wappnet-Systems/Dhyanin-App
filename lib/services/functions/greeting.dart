String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Morning!';
  } else if (hour < 17) {
    return 'Afternoon!';
  }
  return 'Evening!';
}
