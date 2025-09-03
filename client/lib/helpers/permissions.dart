import 'dart:collection';

import 'package:logger/web.dart';

enum Role {
  admin,
  referee,
  headReferee,
  judge,
  judgeAdvisor,
  // scoreKeeper,
  // emcee,
  // av,
}

Role? getRoleFromString(String roleString) {
  switch (roleString) {
    case 'admin':
      return Role.admin;
    case 'referee':
      return Role.referee;
    case 'head_referee':
      return Role.headReferee;
    case 'judge':
      return Role.judge;
    case 'judge_advisor':
      return Role.judgeAdvisor;
    // case 'score_keeper':
    //   return Role.scoreKeeper;
    // case 'emcee':
    //   return Role.emcee;
    // case 'av':
    //   return Role.av;
    default:
      Logger().w('Unknown role string: $roleString');
  }
  return null;
}

extension RoleExtension on Role {
  bool hasPermission(Role necessary) {
    return RoleGraph.instance.hasPermission(this, necessary);
  }
}

class RoleGraph {
  static RoleGraph? _instance;
  static RoleGraph get instance {
    _instance ??= RoleGraph._init();
    return _instance!;
  }

  final Map<Role, Set<Role>> _inheritance = {};

  RoleGraph._init() {
    Logger().i('Initializing role graph');

    // Define roles and their inheritance

    // Super users
    addRoleWithInheritance(Role.admin, []);

    // Referee roles
    addRoleWithInheritance(Role.referee, []);
    addRoleWithInheritance(Role.headReferee, [Role.referee]);

    // Judge roles
    addRoleWithInheritance(Role.judge, []);
    addRoleWithInheritance(Role.judgeAdvisor, [Role.judge]);
  }

  // Add a role with no inheritance
  void addRole(Role role) {
    _inheritance.putIfAbsent(role, () => <Role>{});
  }

  // Add a role with inheritance
  void addRoleWithInheritance(Role role, List<Role> inheritedRoles) {
    final entry = _inheritance.putIfAbsent(role, () => <Role>{});
    entry.addAll(inheritedRoles);
  }

  // Check if role has the required permissions, including inheritance
  bool hasPermission(Role role, Role reqRole) {
    // If the role is admin, bypass all checks
    if (role == Role.admin) {
      return true;
    }

    // Direct match
    if (role == reqRole) {
      return true;
    }

    // BFS to check for inheritance
    final queue = Queue<Role>()..add(role);
    final visited = <Role>{role};

    while (queue.isNotEmpty) {
      final currentRole = queue.removeFirst();

      // Check direct inheritance
      final inheritance = _inheritance[currentRole];
      if (inheritance != null) {
        for (final parent in inheritance) {
          if (parent == reqRole) {
            return true;
          }

          if (visited.add(parent)) {
            queue.add(parent);
          }
        }
      }
    }

    return false;
  }
}
