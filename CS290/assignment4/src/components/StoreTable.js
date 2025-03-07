import React from 'react';
import StoreRow from './StoreRow';

function StoreTable({stores}){
	return(
		<table className="table">
			<caption>Stores in States with Zip Codes</caption>
			<thead>
				<tr>
					<th>City</th>
					<th>State</th>
					<th>Zip Code</th>
				</tr>
			</thead>
			<tbody>
                {stores.map((store, i) => <StoreRow store={store} key ={i} />)}
			</tbody>
			<tfoot>
				//
			</tfoot>
		</table>
	);
}
export default	StoreTable