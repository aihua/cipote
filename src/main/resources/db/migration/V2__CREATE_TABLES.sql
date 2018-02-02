    CREATE TABLE exchange
(
    id integer NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    CONSTRAINT exange_pk PRIMARY KEY (id)
);

CREATE TABLE coin
(
    id integer NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    short_name VARCHAR(10) NOT NULL UNIQUE,
    final boolean NOT NULL DEFAULT false,
    CONSTRAINT coin_pk PRIMARY KEY (id)
);
    
        CREATE TABLE user_info
(
    id integer NOT NULL AUTO_INCREMENT,
    login VARCHAR(255) NOT NULL UNIQUE,
    creation_timestamp timestamp NOT NULL,
    CONSTRAINT user_pk PRIMARY KEY (id)
);
    
CREATE TABLE coin_by_exchange
(
    id integer NOT NULL AUTO_INCREMENT,
    id_coin integer NOT NULL,
    id_exchange integer NOT NULL,
    id_coin_pair integer NOT NULL,
    CONSTRAINT coin_by_exchange_pk PRIMARY KEY (id),
    CONSTRAINT coin_by_exchange_fk0 FOREIGN KEY (id_coin)
        REFERENCES coin (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT coin_by_exchange_fk1 FOREIGN KEY (id_exchange)
        REFERENCES exchange (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT coin_by_exchange_id_coin_pair_fkey FOREIGN KEY (id_coin_pair)
        REFERENCES coin (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
); 
    
    CREATE TABLE coin_per_user
(
    id integer NOT NULL AUTO_INCREMENT,
    id_user integer NOT NULL,
    id_coin_by_exchange integer NOT NULL,
    quantity decimal(30,10) NOT NULL,
    invested decimal(30,2) NOT NULL,
    satoshi_buy numeric NOT NULL,
    buy_date timestamp,
    CONSTRAINT coin_per_user_pk PRIMARY KEY (id),
    CONSTRAINT coin_per_user_fk FOREIGN KEY (id_user)
        REFERENCES user_info (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT coin_by_exange_fk FOREIGN KEY (id_coin_by_exchange)
        REFERENCES coin_by_exchange (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
    
    CREATE TABLE exchange_api
(
    id integer NOT NULL AUTO_INCREMENT,
    id_exchange integer NOT NULL,
    api_url VARCHAR(255) NOT NULL,
    CONSTRAINT exchange_api_pk PRIMARY KEY (id),
    CONSTRAINT exchange_api_fk FOREIGN KEY (id_exchange)
        REFERENCES exchange (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
    
    CREATE TABLE user_group2
(
    id integer NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    CONSTRAINT group_pk PRIMARY KEY (id)
);
    
    CREATE TABLE quotation
(
    id integer NOT NULL AUTO_INCREMENT,
    id_coin_by_exchange integer NOT NULL,
    satoshis decimal(30,10) NOT NULL,
    timestamp timestamp NOT NULL,
    CONSTRAINT quotation_pk PRIMARY KEY (id),
    CONSTRAINT quotation_fk FOREIGN KEY (id_coin_by_exchange)
        REFERENCES coin_by_exchange (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
    
    CREATE TABLE user_group
(
    id integer NOT NULL AUTO_INCREMENT,
    id_group integer NOT NULL,
    id_user integer NOT NULL,
    is_manager boolean NOT NULL,
    CONSTRAINT user_group_pk PRIMARY KEY (id),
    CONSTRAINT user_group_fk0 FOREIGN KEY (id_group)
        REFERENCES user_group2 (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT user_group_fk FOREIGN KEY (id_user)
        REFERENCES user_info (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
    
