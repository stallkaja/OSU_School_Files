
import './App.css';
import HomePage from './pages/HomePage.js'
import CreateExercisePage from './pages/CreateExercisePage.js'
import EditExercisePage from './pages/EditExercisePage.js'
import { BrowserRouter as Router, Route } from 'react-router-dom'
import { useState } from 'react';


function App() {  
const [exerciseToEdit, setExerciseToEdit] = useState();
return (
    <div className="App">
		<Router>
			<Route path='/' exact>
          		<HomePage setExerciseToEdit={setExerciseToEdit}/>
        	</Route>

        	<Route path='/create'>
          		<CreateExercisePage/>
        	</Route>

        	<Route path='/edit'>
          		<EditExercisePage exerciseToEdit={exerciseToEdit} />
        	</Route>
			<footer>
				<p> &copy; 2022 James Stallkamp.</p>
			</footer>
		</Router>
    </div>
  );
}

export default App;
