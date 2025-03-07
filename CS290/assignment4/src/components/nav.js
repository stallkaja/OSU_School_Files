import React from 'react';
import { Link } from 'react-router-dom';

function nav(){
    return(
        <>
            <Link className="link" to="/{|index.html|}">Home</Link>
            <Link className="link" to="/order">Order</Link>
            <Link className="link" to="/stores">Stores</Link>
        </>

    );
}

export default nav