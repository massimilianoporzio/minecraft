class PlayerData {
  //*health
  //*hunger
  //state: walkingLeft
  ComponentMotionState motionState = ComponentMotionState.idle;
}

enum ComponentMotionState {
  walkingLeft,
  walkingRight,
  idle,
  jumping,
}
