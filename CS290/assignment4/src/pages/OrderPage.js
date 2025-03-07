import React from 'react';
import ItemTable from '../components/ItemTable';

function OrderPage({items}){
	return(
		<article className="app-article">
			<h2>Order items here</h2>
			<p>Select the quantity of each item up to 10.</p>
			<ItemTable items={items}/>
		</article>
	);
}
export default	OrderPage