import React from 'react';
import { useState, useEffect } from 'react';
import { useHistory, Link } from 'react-router-dom';
import ExerciseTable from '../components/ExerciseTable';

export default function HomePage({ setExerciseToEdit }) {
const history = useHistory();
const [exercises, setExercises] = useState([]);

const loadExercises = async () => {
    const response = await fetch('/exercises');
    const data = await response.json();
    setExercises(data);
  }

useEffect(() =>  loadExercises(), []);

const onDelete = async _id => {


    // Make a DELETE request
    const response = await fetch(`/exercises/${_id}`, {method: 'DELETE'});
    if (response.status === 204) {
      setExercises(exercises.filter(e => e._id !== _id));
    } else {
      console.error(`Failed to delete exercise with _id ${_id} with status \
        code = ${response.status}`)
    }
};

const onEdit = exercise => {
    setExerciseToEdit(exercise);
    history.push('/edit');
  };

  return (
    <>
      <h1>Exercise Tracker App</h1>

      <ExerciseTable exercises={exercises} onDelete={onDelete} onEdit={onEdit}/>

      <br/>
		<h2 style={{color: "white"}}><Link to='/create'>Create an exercise</Link></h2>
      
    </>
  )
}
