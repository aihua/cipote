INSERT INTO coin (NAME, SHORT_NAME, FINAL) VALUES('Bitcoin', 'BTC', false);
INSERT INTO coin (NAME, SHORT_NAME, FINAL) VALUES('Euro', 'EUR', true);
INSERT INTO coin_by_exchange (ID_COIN, ID_EXCHANGE, ID_COIN_PAIR) VALUES((SELECT ID FROM coin WHERE SHORT_NAME = 'BTC'), (SELECT ID FROM exchange WHERE NAME = 'GDAX'), (SELECT ID FROM coin WHERE SHORT_NAME = 'EUR'));
INSERT INTO user_info (LOGIN, CREATION_TIMESTAMP) VALUES ('a', LOCALTIMESTAMP);