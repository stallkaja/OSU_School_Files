import './App.css';
import stores from './data/stores';
import items from './data/items';
import React from 'react';
import {BrowserRouter as Router, Route} from 'react-router-dom'

//components
import Navigation from './components/nav.js'

//pages
import HomePage from './pages/HomePage.js'
import OrderPage from './pages/OrderPage.js'
import StoresPage from './pages/StoresPage.js'
function App() {  
  return (
    <div className="App">
		<Router>
			<header className="App-Header">
				<h1>Online Store Title</h1>
				<p><cite>James Stallkamp</cite> Assignment 4 CS290</p>
			</header>
			<Navigation />
			<main>
				<Route path ="/{|index.html|}" exact><HomePage /></Route>
				<Route path ="/order"><OrderPage items={items} /></Route>
				<Route path ="/stores"><StoresPage stores={stores} /></Route>
			</main>
			<footer>
				<p> &copy; 2022 James Stallkamp.</p>
			</footer>
		</Router>
    </div>
  );
}

export default App;
