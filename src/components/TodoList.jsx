import React from 'react'
import TodoCard from './TodoCard'

export default function TodoList() {
    let todos = [
        'Buy groceries',
        'Eat dinner',
        'Read a book',
    ]

    return (
        <ul className='main'>
            {todos.map((todo, todoIndex) => {
                return (
                    <TodoCard key={todoIndex}>
                        <p>{todo}</p>
                    </TodoCard>
                )
            })}
        </ul>
    )
}