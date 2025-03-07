import React, { useState} from 'react';

function ZipSearch() {
    const [zipCode, setZipCode] = useState('');
    
    return(
        <form action="" method="">
            <fieldset>
                <legend>Enter your zip code:</legend>
                <label>Zip code</label>
                    <input type="number"
                        value={zipCode}
                        id="zip"
                        name={zipCode}
                        placeholder="12345"
                        size="5"
                        maxLength="5"
                        min="5"
                        onChange={e=> setZipCode(e.target.value)}
                        ></input>
                <label>
                        <button name="alert" id="alert" onClick={e=>{
                            var message = document.getElementById("zip").value;
                            alert('You entered: '+message);
                            e.preventDefault();
                        }}>Submit</button>
                </label>
            </fieldset>
        </form>
    );
}
export default ZipSearch