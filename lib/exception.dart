// login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// register exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic exceptions

class GenericAuthException implements Exception {}


class ImageNullException implements Exception {}

class NotFoundGroupException implements Exception {}

class JoinedOrRequestedException implements Exception {}

class NotJoinedOrRequestedYetException implements Exception {}

class YouAreOnlyOwnerOfGroupException implements Exception {}