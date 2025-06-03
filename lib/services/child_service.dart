import 'package:pfa/repositories/child_repository.dart';

class ChildService {
  final ChildRepository _childRepository;
  ChildService({required ChildRepository childRepository})
      : _childRepository = childRepository;

  Future<List<String>> getEducators({required String childId}) async {
    return _childRepository.getEducatorsForChild(childId);
  }

  Future<String> addEducator(
      {required String childId, required String educatorEmail}) async {
    return _childRepository.addEducatorByEmail(childId, educatorEmail);
  }

  Future<String> removeEducator(
      {required String childId, required String educatorEmail}) async {
    return _childRepository.removeEducatorByEmail(childId, educatorEmail);
  }
}
