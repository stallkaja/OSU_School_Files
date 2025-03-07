import React from 'react';
import ItemRow from './ItemRow';

function ItemTable({items}){
	return(
		<table className="table">
			<caption>Items for sale</caption>
			<thead>
				<tr>
					<th>Item</th>
					<th>Price</th>
					<th>Quantity</th>
				</tr>
			</thead>
			<tbody>
				{items.map((item, i) => <ItemRow item={item} key ={i} />)}
			</tbody>
			<tfoot>
				//
			</tfoot>
		</table>
	);
}
export default	ItemTable