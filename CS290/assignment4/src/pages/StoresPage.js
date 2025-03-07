import React from 'react';
import StoreTable from '../components/StoreTable';
import ZipSearch from '../components/ZipSearch';

function StoresPage({stores}){
	return(
		<article className="app-article">
            <h2>List of Stores</h2>
			<p>Use the form below to find the store closest to you</p>
			<StoreTable stores={stores}/>
            <ZipSearch/>
		</article>
	);
}
export default	StoresPage