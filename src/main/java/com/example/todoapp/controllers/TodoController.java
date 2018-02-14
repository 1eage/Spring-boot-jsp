package com.example.todoapp.controllers;

import javax.validation.Valid;
import com.example.todoapp.models.Todo;
import com.example.todoapp.repositories.TodoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
//@RequestMapping("/api")
@CrossOrigin("*")
public class TodoController {

    @Autowired
    TodoRepository todoRepository;

   // @GetMapping("/todos")
    @RequestMapping(value="/todos",method=RequestMethod.GET,produces="application/json")
    public List<Todo> getAllTodos(Map<String, Object> model) {
        Sort sortByCreatedAtDesc = new Sort(Sort.Direction.DESC, "createdAt");
        //model.put("todos", lsttodo);
        return todoRepository.findAll(sortByCreatedAtDesc);
       
       // System.out.println("29"+lsttodo);
       // return "UserManagement";
    }

   // @PostMapping("/todos")
    @RequestMapping(value="/todos",consumes = MediaType.APPLICATION_JSON_VALUE, method = RequestMethod.POST)
    public Todo createTodo(@Valid @RequestBody Todo todo) {
        
        System.out.println("38");
        todo.setCompleted(false);
        
        return todoRepository.save(todo);
    }

    //@GetMapping(value="/todos/{id}")
    @RequestMapping(value="/todos/{id}",consumes = MediaType.APPLICATION_JSON_VALUE, method = RequestMethod.GET)
    public ResponseEntity<Todo> getTodoById(@PathVariable("id") String id) {
        Todo todo = todoRepository.findOne(id);
        System.out.println("45");
        if(todo == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } else {
            return new ResponseEntity<>(todo, HttpStatus.OK);
        }
    }

   // @PutMapping(value="/todos/{id}")
    @RequestMapping(value="/todostatus/",consumes = MediaType.APPLICATION_JSON_VALUE, method = RequestMethod.PUT)
    public Todo updateTodo(@Valid @RequestBody Todo todo) {
        Todo todoData = todoRepository.findOne(todo.getId());
        System.out.println("60"+todo.getId());
        if(todoData == null) {
            //return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        todoData.setTitle(todo.getTitle());
        System.out.println("65"+todoData.getCompleted());
        if(!todoData.getCompleted()) {
        	System.out.println("false");
        	todoData.setCompleted(true);
        }else {
        	System.out.println("false");
        todoData.setCompleted(false);
        }
        System.out.println("66"+todo.getId());
        return todoRepository.save(todoData);
       // return new ResponseEntity<>(updatedTodo, HttpStatus.OK);
    }

    //@DeleteMapping(value="/todos/{id}")
    @RequestMapping(value="/todos/",consumes = MediaType.APPLICATION_JSON_VALUE, method = RequestMethod.DELETE)
    public void deleteTodo(@Valid @RequestBody Todo todo) {
    	System.out.println("71"+todo.getId());
        todoRepository.delete(todo.getId());
        
       // return new ResponseEntity(HttpStatus.OK);
    }
}