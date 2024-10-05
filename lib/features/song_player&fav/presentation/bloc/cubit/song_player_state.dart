/// Base class for all states related to Song Player
abstract class SongPlayerState {}

/// State representing the loading state for Song player
class SongPlayerLoading extends SongPlayerState {}

/// State representing the Loaded state for Song player
class SongPlayerLoaded extends SongPlayerState {}

/// State representing the failure state for Song player
class SongPlayerFailure extends SongPlayerState {}
