import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gig_tasks/core/constants/app_constants.dart';
import 'package:gig_tasks/core/errors/exceptions.dart';
import 'package:gig_tasks/features/tasks/data/models/task_model.dart';
import 'package:gig_tasks/features/tasks/data/sources/task_remote_data_source.dart';

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore _firestore;

  const TaskRemoteDataSourceImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _tasksCollection =>
      _firestore.collection(AppConstants.tasksCollection);

  @override
  Stream<List<TaskModel>> watchTasks(String userId) {
    try {
      return _tasksCollection
          .where(AppConstants.fieldUserId, isEqualTo: userId)
          .orderBy(AppConstants.fieldDueDate)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => TaskModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      throw ServerException('Failed to watch tasks: $e');
    }
  }

  @override
  Future<List<TaskModel>> getTasks(String userId) async {
    try {
      final snapshot = await _tasksCollection
          .where(AppConstants.fieldUserId, isEqualTo: userId)
          .orderBy(AppConstants.fieldDueDate)
          .get();
      return snapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to get tasks.');
    } catch (e) {
      throw ServerException('Failed to get tasks: $e');
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final docRef = _tasksCollection.doc(task.id);
      await docRef.set(task.toFirestore());
      final snapshot = await docRef.get();
      return TaskModel.fromFirestore(snapshot);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to create task.');
    } catch (e) {
      throw ServerException('Failed to create task: $e');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final docRef = _tasksCollection.doc(task.id);
      await docRef.update(task.toFirestore());
      final snapshot = await docRef.get();
      return TaskModel.fromFirestore(snapshot);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to update task.');
    } catch (e) {
      throw ServerException('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await _tasksCollection.doc(taskId).delete();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete task.');
    } catch (e) {
      throw ServerException('Failed to delete task: $e');
    }
  }

  @override
  Future<TaskModel> toggleTaskComplete(TaskModel task) async {
    try {
      final docRef = _tasksCollection.doc(task.id);
      await docRef.update({
        AppConstants.fieldIsCompleted: task.isCompleted,
        AppConstants.fieldUpdatedAt:
            Timestamp.fromDate(task.updatedAt),
      });
      final snapshot = await docRef.get();
      return TaskModel.fromFirestore(snapshot);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to toggle task.');
    } catch (e) {
      throw ServerException('Failed to toggle task: $e');
    }
  }
}