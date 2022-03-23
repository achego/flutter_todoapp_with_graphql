class QueryMutation {
  String createTodo({required String task, String status = "Pending"}) {
    return """
    mutation {
      createTodo(input : {task : "$task", status : "$status"}) {
        id
        status
        task
        timeAdded
      }
    }
""";
  }

  String deleteTodo(int todoId) {
    return """
    mutation {
      deleteTodo(todoId : $todoId) {
        id
      }
    }
""";
  }

  String getTodos() {
    return """
    query {
      getTodos(status : "", search : "") {
        id
        task
        timeAdded
        status
      }
    }
""";
  }
}
