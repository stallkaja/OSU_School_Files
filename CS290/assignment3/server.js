'use strict';

const PORT = 3000;

// The variable stocks has the same value as the variable stocks in the file 'stocks.js'
const stocks = require('./stocks.js').stocks;

const express = require("express");
const app = express();


app.use(express.urlencoded({
    extended: true
}));

app.use(express.static('public'));
// Note: Don't add or change anything above this line.

// Add your code here

app.get("/orderStocks", (req, res) => {
	const stockName = req.query.stock;
    const stockQty = req.query.stockQty;
	var stockPrice
	var totalPrice
	for (const stock of stocks){
		console.log(stock);
		console.log(stock.company);
		if(stockName === stock.company){
			stockPrice = stock.price
			console.log(stockPrice);
		}
	}
	totalPrice = stockPrice * stockQty;
    //res.send(`Hi ${stockName}. Your stockQty is ${stockQty}. The request was sent using the HTTP method GET`);
	res.send(`You placed an order to buy ${stockQty} stocks of ${stockName}. The price of one stock is ${stockPrice} and the total price for this order is ${totalPrice}.`);
});

app.get("/searchStocks", (req, res) => {
	const searchType = req.query.searchType;
	console.log(searchType)
	var targetStock = findStockByPrice(searchType);
	console.log(targetStock);
	res.send(targetStock);
});

function findStockByPrice(searchType){
	var price=stocks[0].price;
	var currentStock;
	if(searchType==="highest"){
		for (const stock of stocks){
			if(stock.price > price){
			price = stock.price;
			currentStock=stock;
			}
		}
	}
	else if(searchType==="lowest"){
		console.log("searching for lowest");
		for (const stock of stocks){
			if(stock.price < price){
			price = stock.price;
			currentStock=stock;
			}
		}
	}
	return currentStock;
}
// Note: Don't add or change anything below this line.
app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}...`);
});