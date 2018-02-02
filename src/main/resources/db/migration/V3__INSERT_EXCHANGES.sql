INSERT INTO exchange (NAME) VALUES('GDAX');
INSERT INTO exchange (NAME) VALUES('BINANCE');
INSERT INTO exchange (NAME) VALUES('BITTREX');


INSERT INTO exchange_api (ID_EXCHANGE, API_URL) VALUES((SELECT ID FROM exchange WHERE NAME = 'GDAX'), 'https://api.gdax.com/products/{0}-{1}/ticker');
INSERT INTO exchange_api (ID_EXCHANGE, API_URL) VALUES((SELECT ID FROM exchange WHERE NAME = 'BINANCE'), 'https://api.binance.com/api/v1/ticker/price?symbol={0}{1}');
INSERT INTO exchange_api (ID_EXCHANGE, API_URL) VALUES((SELECT ID FROM exchange WHERE NAME = 'BITTREX'), 'https://bittrex.com/api/v1.1/public/getticker?market={1}-{0}');

