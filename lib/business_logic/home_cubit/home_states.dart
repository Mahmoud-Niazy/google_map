abstract class HomeStates {}

class HomeInitialState extends HomeStates{}

class GetUserLocationLoadingState extends HomeStates{}
class GetUserLocationSuccessfullyState extends HomeStates{}
class GetUserLocationErrorState extends HomeStates{}

class GetAutoCompletePlacesLoadingState extends HomeStates{}
class GetAutoCompletePlacesSuccessfullyState extends HomeStates{}
class GetAutoCompletePlacesErrorState extends HomeStates{}

class GetPlaceDetailsLoadingState extends HomeStates{}
class GetPlaceDetailsSuccessfullyState extends HomeStates{}
class GetPlaceDetailsErrorState extends HomeStates{}

class LoadPlaceDirectionLoadingState extends HomeStates{}
class LoadPlaceDirectionSuccessfullyState extends HomeStates{}
class LoadPlaceDirectionErrorState extends HomeStates{}

class AddMarkersState extends HomeStates{}

class RemoveEveryThingState extends HomeStates{}

class GetProfileImageLoadingState extends HomeStates{}
class GetProfileImageSuccessfullyState extends HomeStates{}
class GetProfileImageErrorState extends HomeStates{}

class UploadProfileImageSuccessfullyState extends HomeStates{}


class ShowTimeAndDateState extends HomeStates{}

class CreateTableLoadingState extends HomeStates{}
class CreateTableSuccessfullyState extends HomeStates{}
class CreateTableErrorState extends HomeStates{}

class InsertIntoDatabaseLoadingState extends HomeStates{}
class InsertIntoDatabaseSuccessfullyState extends HomeStates{}
class InsertIntoDatabaseErrorState extends HomeStates{}

class GetDataFromDatabaseLoadingState extends HomeStates{}
class GetDataFromDatabaseSuccessfullyState extends HomeStates{}
class GetDataFromDatabaseErrorState extends HomeStates{}

class ClearDatabaseLoadingState extends HomeStates{}
class ClearDatabaseSuccessfullyState extends HomeStates{}
class ClearDatabaseErrorState extends HomeStates{}