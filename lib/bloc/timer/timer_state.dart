import 'package:equatable/equatable.dart';

abstract class TimerState extends Equatable {
  final int duration;

  const TimerState(this.duration);

  /// state instants compare each other by duration
  @override
  List<Object> get props => [duration];
}

class TimerInitial extends TimerState {
  const TimerInitial(int duration) : super(duration);
}

class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(int duration) : super(duration);
}

class TimerRunPause extends TimerState {
  const TimerRunPause(int duration) : super(duration);
}

class TimerRunComplete extends TimerState {
  /// at this state, timer's value is 0
  const TimerRunComplete() : super(0);
}