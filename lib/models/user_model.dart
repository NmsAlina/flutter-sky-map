class UserPosition {
  double azimuth;  //angle between top of the phone and actual North
  double pitch;    //rotation around x axe is denoted as pitch 

  UserPosition({
    required this.azimuth,
    required this.pitch,
  });
}
