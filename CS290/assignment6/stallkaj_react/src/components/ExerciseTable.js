import React from 'react';
import ExerciseRow from '../components/ExerciseRow.js'

function ItemTable({exercises, onDelete, onEdit}){
	return(
		<table className="table">
			<caption>Exercise</caption>
			<thead>
				<tr>
                <th> Name </th>
                <th> Reps </th>
                <th> Weight </th>
                <th> Unit </th>
                <th> Date </th>
                <th> </th>
                <th> </th>
				</tr>
			</thead>
			<tbody>
                {exercises.map((exercise, i) => <ExerciseRow exercise={exercise} onDelete={onDelete} onEdit={onEdit} key={i}/> )}
			</tbody>
		</table>
	);
}
export default	ItemTable